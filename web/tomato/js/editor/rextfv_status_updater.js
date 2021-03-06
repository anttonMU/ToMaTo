
var RexTFV_status_updater = Class.extend({
	init: function(options) {
		this.options = options;
		this.elements = [];
	},
	updateFirst: function(t) { //Takes RexTFV_status_updater as argument.
	    entry = t.elements.shift();
        var elExists = true;
        var mustRemove = false;
        var was_actual_run = true;  // set to false to indicate that this was not an actual run.

        if (entry.element in editor.topology.elements) { //element exists
        	if ((new Date(editor.topology.elements[entry.element].data.info_next_sync * 1000) - new Date()) < -2000) {
            	editor.topology.elements[entry.element].updateSynchronous(undefined, undefined, true);
            } else {
            	was_actual_run = false;
            }
        } else {
            elExists = false;
        }
		if (elExists &&
			editor.topology.elements[entry.element].rextfvStatusSupport() &&
			editor.topology.elements[entry.element].data.rextfv_run_status.running) {

		} else {
			mustRemove = (entry.timeout < new Date())
		}

		if (!mustRemove || !was_actual_run) t.elements.push(entry);

		if (was_actual_run) {
			return true;
		} else {
			return false;
		}
	},
	updateSome: function(t) { //this should be called by a timer. Takes RexTFV_status_updater as argument.
		                      //update only the first five elements of the array. This boundary is to avoid server overload.
        var max_tries = t.elements.length; // number of tries until whole list is cycled
        var to_update = 1; // maximum number of requests to do per second. fixme: maxe this configurable.
        var count = Math.min(max_tries, to_update); // maximum number of requests to do per second
        while (max_tries>0 && count>0) {
        	max_tries = max_tries - 1;
        	if (t.updateFirst(t)) {
        		count = count - 1;
        	}
        }
	},
	addIfNeeded: function(el) {
		if (el.rextfvStatusSupport() &&
			el.data.rextfv_run_status.running) {
				this.add(el, 1);
			}
	},
	add: function(el,timeout) { //every entry has a number of retries and an element ID attached to it.
								// timeout is a time in milliseconds when the entry should be removed.
								// before the entry is removed due to timeout, it is checked a last time.
								// when an element has been found to have running rextfv script, it is never removed, regardless of timeout.
		timeout_real = new Date() - (-timeout);
		

		//first, search whether this element is already monitored. If yes, update number of tries if necessary (keep the bigger one). exit funciton if found.
		for (var i=0; i<this.elements.length; i++) {
			if (this.elements[i].element == el.id) {
				if (this.elements[i].timeout < timeout_real)
					this.elements[i].timeout = timeout_real;
				return
			}
		}
		//if the search hasn't found anything, simply append this.
		this.elements.push({
			element: el.id,
			timeout: timeout_real
		})
	},
	// usually only called by this. removes an entry.
	remove: function(entry) {
		for (var i=0; i<this.elements.length; i++) {
			entry_found = this.elements[i];
			if (entry_found == entry) {
				this.elements.splice(i,1);
				return;
			}
		}
	}
});

# -*- coding: utf-8 -*-
# ToMaTo (Topology management software) 
# Copyright (C) 2014, Integrated Communication Systems Lab, University of Kaiserslautern
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

from .. import dump

def dump_count():
	"""
	returns the total number of error dumps
	"""
	return dump.getCount()

def dump_list(after=None):
	"""
	returns a list of dumps.
	
	Parameter *after*: 
		If set, only include dumps which have a timestamp after this time.

		Parameter *list_only*:
			If True, only include dump IDs.

		Parameter *include_data*:
			If True, include detailed data. This may be about 1M per dump.

		Parameter *compress_data*:
			If True and include_data, compress the detailed data before returning. It may still be around 20M per dump after compressing.
	"""
	return dump.getAll(after=after)

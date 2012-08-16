# -*- coding: utf-8 -*-
# ToMaTo (Topology management software) 
# Copyright (C) 2010 Dennis Schwerdel, University of Kaiserslautern
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


def host_info():
    """
    Retrieves general information about the host. 
    
    @return: general Information about the host
    @rtype: dict    
    """
    return {
        "hostmanager": {
            "version": config.VERSION,
        },
        "fileserver_port": config.FILESERVER["port"],
        "site": config.SITE,
        "coordinates": config.COORDINATES,
    }

def host_capabilities():
    """
    Retrieves the capabilities of the host. 
    
    @return: Information about the host capabilities
    @rtype: dict
    """
    element_types = {}
    for type_, class_ in tomato.elements.TYPES.iteritems():
        caps = {}
        for cap in ["cap_actions", "cap_attrs", "cap_children", "cap_parent", "cap_con_paradigms"]:
            caps[cap] = getattr(class_, cap.upper())
        element_types[type_] = caps
    connection_types = {}
    for type_, class_ in tomato.connections.TYPES.iteritems():
        caps = {}
        for cap in ["cap_actions", "cap_attrs", "cap_con_paradigms"]:
            caps[cap] = getattr(class_, cap.upper())
        connection_types[type_] = caps
    return {
        "element_types": element_types,
        "connection_types": connection_types,
        "resource_types": dict([(type_, {}) for type_ in tomato.resources.TYPES]),
    }

import tomato.elements
import tomato.resources
from tomato import config
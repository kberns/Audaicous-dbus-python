#!/usr/bin/env python
#	python-dbus used for getting the information from Audaicous
#				Copyright 2019 krizoek <krizoek@gmail.com>
#
#	a remix of: https://snippets.siftie.com/vkolev/copy-current-playing-song-to-clipboard/
#       playCopy 1.0 (python script)
#       
#       Copyright 2009 Vladimir Kolev <admin@vladimirkolev.com>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.
#	
#	Special thanks to Umang <umang.me@gmail.com> for the changes in the script.
#	See section 4. in INSTALL file for the changes
#


import os
import commands
import re
import dbus
from dbus import Bus, DBusException
bus = Bus(Bus.TYPE_SESSION)

def cur_song():
	if "audacious" in os.popen('ps -A | grep audacious').readline():
		remote_object = bus.get_object("org.atheme.audacious", "/org/atheme/audacious")
		iface = dbus.Interface(remote_object, 'org.atheme.audacious')
		pos=iface.Position()
		pos = iface.Position()
		playLength = iface.Length()
		length = iface.SongLength(pos)
		length = (length > 0) and ("%d:%02d" % (length / 60, length % 60)) or "stream"
		playSecs = iface.Time() / 1000
		info = iface.Info()
		song=iface.SongTuple(pos,"title")
		matchObj = re.search( r'([^\{]*)\s', song, re.M|re.I)
		song= matchObj.group(1) 
		song=re.sub("\([^\)]*\)", "", song)
		song=re.sub("\s\s", " ", song)
		song=re.sub("\s$", "", song)
		return song
	else
		return "audacious not running"
if __name__ == "__main__":
	import pygtk
	import gtk	
	# Define the clipboard
	clipboard = gtk.clipboard_get()
	# Get the song name from cur_song(), copy the string to the clipboard and store it
	clipboard.set_text(cur_song())
	clipboard.store()

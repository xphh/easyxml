easyxml
=======

Simply convert Lua table to/from XML(with no attribution) in pure Lua.

For example:

[in Lua table]
	local t = {
		xxx = 1,
		yyy = {'a', 'b'}
	}

[in XML format]
	<xml>
		<xxx>1</xxx>
		<yyy>a</yyy>
		<yyy>b</yyy>
	</xml>
	
Usage:

local xml = require "easyxml"

xml.encode(t)		-- return xml

xml.decode(xml)		-- return table

See test.lua for more details.
	

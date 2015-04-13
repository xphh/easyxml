--[[
The MIT License (MIT)

Copyright (c) 2014 Ping.X

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
local xml = require "easyxml"

local t = {
	f1 = 1,
	f2 = 'xxx',
	f3 = {
		{
			TTT = 346457,
			GGG = 'ggg<ss>'
		},
		{
			HHH = {1,2,3,4},
			JJJ = {
				aaa = 1,
				bbb = 2
			}
		},
		123,
		456
	}
}

local str = xml.encode(t)

print(str)

print(xml.encode(xml.decode(str)))

local strxml = [[
<body>
	<x3>
		<z1>111111</z1>
	</x3>
	<x1>qqq</x1>
	<x2>
		<y1>asd</y1>
		<y2>222</y2>
		<y3>333</y3>
	</x2>
	<x3>
		<z1>333333</z1>
	</x3>
	<x4>vvvv</x4>
	<x3>
		<z1>222222</z1>
	</x3>
</body>
]]

local tpl = {
	x1 = 1,
	x2 = {
		y1 = "aaa",
		y2 = "bbb",
	},
	x3 = {
		{z1 = 123}
	},
}

local t2 = xml.decode(strxml, "body", tpl)
print(xml.encode(t2))


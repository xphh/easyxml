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

local function isarray(t)
	if t[1] == nil then
		return false
	else
		return true
	end
end

local function encode(t, key, level)
	local xml = ''
	t = t or {}
	key = key or 'xml'
	level = level or 0
	local tab = string.rep('\t', level)
	if type(t) == 'table' then
		if isarray(t) then
			for i = 1, #t do
				xml = xml..encode(t[i], key, level)
			end
		else
			xml = xml..tab..'<'..key..'>\n'
			for i, v in pairs(t) do
				xml = xml..encode(v, i, level + 1)
			end
			xml = xml..tab..'</'..key..'>\n'
		end
	else
		local str = string.gsub(string.gsub(t, '<', '&lt;'), '>', '&gt;')
		xml = xml..tab..'<'..key..'>'..str..'</'..key..'>\n'
	end
	return xml
end

local function getnode(xml)
	local b1, b2, key = string.find(xml, '<(%w+)>')
	if not b1 then
		return
	end
	local e1, e2 = string.find(xml, '</'..key..'>')
	if not e1 then
		return
	end
	return b1, e2, key, string.sub(xml, b2 + 1, e1 - 1)
end

local function decode_recur(xml)
	local t = {}
	local count = 0
	local isarr = false
	while true do
		local _, e, key, val = getnode(xml)
		if not key then
			if count == 0 then
				return xml
			else
				break
			end
		else
			if not t[key] then
				t[key] = decode_recur(val)
				count = count + 1
			else
				if not isarr then
					t[key] = {t[key], decode_recur(val)}
					isarr = true
				else
					t[key][#t[key] + 1] = decode_recur(val)
				end
			end
			xml = string.sub(xml, e + 1)
		end
	end
	return t
end

local function decode(xml, require_key)
	require_key = require_key or 'xml'
	local _, e, key, val = getnode(xml)
	if key == require_key then
		return decode_recur(val)
	end
end

return {
	encode = encode,
	decode = decode
}

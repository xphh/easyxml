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

local function table_is_array(t)
	return type(t) == "table" and t[1] ~= nil
end

local function table_is_empty(t)
	return type(t) == "table" and _G.next(t) == nil
end

local function encode(t, key, level)
	local xml = ''
	t = t or {}
	key = key or 'xml'
	level = level or 0
	local tab = string.rep('\t', level)
	if type(t) == 'table' then
		if table_is_array(t) then
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
	local isarr = false
	while true do
		local _, e, key, val = getnode(xml)
		if key == nil then
			break
		end
		if t[key] == nil then
			t[key] = decode_recur(val)
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
	if table_is_empty(t) then
		return xml
	end
	return t
end

local function decode_recur_tpl(xml, tpl)
	if type(tpl) == "number" then
		return tonumber(xml)
	elseif type(tpl) == "string" then
		if tpl:find('%[int%]') == 1 or tpl:find('%[long%]') == 1 or tpl:find('%[double%]') == 1 then
			return tonumber(xml)
		elseif tpl:find('%[bool%]') == 1 then
			return xml == 'true'
		else
			return xml
		end
	end
	local t = {}
	while true do
		local _, e, key, val = getnode(xml)
		if key == nil then
			break
		end
		if tpl[key] ~= nil then
			if table_is_array(tpl[key]) then
				t[key] = t[key] or {}
				t[key][#t[key] + 1] = decode_recur_tpl(val, tpl[key][1])
			else
				t[key] = decode_recur_tpl(val, tpl[key])
			end
		end
		xml = string.sub(xml, e + 1)
	end
	return t
end

local function decode(xml, require_key, tpl)
	require_key = require_key or 'xml'
	local _, e, key, val = getnode(xml)
	if key == require_key then
		if tpl == nil then
			return decode_recur(val)
		else
			return decode_recur_tpl(val, tpl)
		end
	end
end

return {
	encode = encode,
	decode = decode
}

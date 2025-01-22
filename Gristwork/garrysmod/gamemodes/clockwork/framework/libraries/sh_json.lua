--[[
	JSON Encoder and Parser for Lua 5.1
	
	Copyright © 2007 Shaun Brown (http://www.chipmunkav.com).
	All Rights Reserved.
	 
	Permission is hereby granted, free of charge, to any person 
	obtaining a copy of this software to deal in the Software without 
	restriction, including without limitation the rights to use, 
	copy, modify, merge, publish, distribute, sublicense, and/or 
	sell copies of the Software, and to permit persons to whom the 
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be 
	included in all copies or substantial portions of the Software.
	If you find this software useful please give www.chipmunkav.com a mention.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
	ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
	CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local Clockwork = Clockwork;
local setmetatable = setmetatable;
local tonumber = tonumber;
local tostring = tostring;
local assert = assert;
local error = error;
local pairs = pairs;
local type = type;
local string = string;
local table = table;
local math = math;

Clockwork.json = Clockwork.kernel:NewLibrary("Json");

local StringBuilder = {
	buffer = {}
};

function StringBuilder:New()
	local object = {};
		setmetatable(object, self);
		self.__index = self;
		object.buffer = {};
	return object;
end;

function StringBuilder:Append(s)
	self.buffer[#self.buffer + 1] = s;
end;

function StringBuilder:ToString()
	return table.concat(self.buffer);
end;

local JsonWriter = {
	backslashes = {
		['\b'] = "\\b",
		['\t'] = "\\t",	
		['\n'] = "\\n", 
		['\f'] = "\\f",
		['\r'] = "\\r", 
		['"']  = "\\\"", 
		['\\'] = "\\\\", 
		['/']  = "\\/"
	}
};

function JsonWriter:New()
	local object = {};
		object.writer = StringBuilder:New();
		setmetatable(object, self);
		self.__index = self;
	return object;
end;

function JsonWriter:Append(s)
	self.writer:Append(s);
end;

function JsonWriter:ToString()
	return self.writer:ToString();
end;

function JsonWriter:Write(object)
	local objectType = type(object)
	
	if (objectType == "nil") then
		self:WriteNil();
	elseif (objectType == "boolean") then
		self:WriteString(object);
	elseif (objectType == "number") then
		self:WriteString(object);
	elseif (objectType == "string") then
		self:ParseString(object);
	elseif (objectType == "table" or objectType == "vector") then
		self:WriteTable(object);
	elseif (objectType == "function") then
		self:WriteFunction(object);
	elseif (objectType == "thread") then
		self:WriteError(object);
	elseif (objectType == "userdata") then
		self:WriteError(object);
	end;
end;

function JsonWriter:WriteNil()
	self:Append("null");
end;

function JsonWriter:WriteString(object)
	self:Append(tostring(object));
end;

function JsonWriter:ParseString(s)
	self:Append('"');
		self:Append(string.gsub(s, "[%z%c\\\"/]", function(n)
			local c = self.backslashes[n]
			
			if (c) then
				return c;
			end;
			
			return string.format("\\u%.4X", string.byte(n))
		end));
	self:Append('"');
end;

function JsonWriter:IsArray(t)
	local count = 0
	local isindex = function(k) 
		if (type(k) == "number" and k > 0) then
			if (math.floor(k) == k) then
				return true;
			end;
		end;
		
		return false;
	end;
	
	for k,v in pairs(t) do
		if (!isindex(k)) then
			return false, '{', '}';
		else
			count = math.max(count, k);
		end;
	end;
	
	return true, '[', ']', count;
end

function JsonWriter:WriteTable(t)
	local ba, st, et, n = self:IsArray(t);
	
	self:Append(st);
	
	if (ba) then		
		for i = 1, n do
			self:Write(t[i]);
			
			if (i < n) then
				self:Append(',');
			end;
		end;
	else
		local first = true;
		
		for k, v in pairs(t) do
			if (!first) then
				self:Append(',');
			end;
			
			first = false;			
			self:ParseString(k);
			self:Append(':');
			self:Write(v);		
		end;
	end;
	
	self:Append(et)
end

function JsonWriter:WriteError(object)
	error(string.format("Encoding of %s unsupported", tostring(object)));
end;

function JsonWriter:WriteFunction(object)
	if (object == Null) then 
		self:WriteNil();
	else
		self:WriteError(object);
	end;
end;

local StringReader = {
	s = "",
	i = 0
};

function StringReader:New(s)
	local object = {};
		setmetatable(object, self);
		self.__index = self;
		object.s = s or object.s;
	return object;
end;

function StringReader:Peek()
	local i = self.i + 1;
	
	if (i <= #self.s) then
		return string.sub(self.s, i, i);
	end;
	
	return nil;
end;

function StringReader:Next()
	self.i = self.i + 1;
	
	if (self.i <= #self.s) then
		return string.sub(self.s, self.i, self.i);
	end;
	
	return nil;
end;

function StringReader:All()
	return self.s;
end;

local JsonReader = {
	escapes = {
		['t'] = '\t',
		['n'] = '\n',
		['f'] = '\f',
		['r'] = '\r',
		['b'] = '\b',
	}
};

function JsonReader:New(s)
	local object = {};
		object.reader = StringReader:New(s);
		setmetatable(object, self);
		self.__index = self;
	return object;
end;

function JsonReader:Read()
	self:SkipWhiteSpace();
	
	local peek = self:Peek();
	
	if (peek == nil) then
		error(string.format("Nil string: '%s'", self:All()));
	elseif (peek == '{') then
		return self:ReadObject();
	elseif (peek == '[') then
		return self:ReadArray();
	elseif (peek == '"') then
		return self:ReadString();
	elseif (string.find(peek, "[%+%-%d]")) then
		return self:ReadNumber();
	elseif (peek == 't') then
		return self:ReadTrue();
	elseif (peek == 'f') then
		return self:ReadFalse();
	elseif (peek == 'n') then
		return self:ReadNull();
	elseif (peek == '/') then
		self:ReadComment();
		
		return self:Read();
	else
		error(string.format("Invalid input: '%s'", self:All()));
	end;
end;

function JsonReader:ReadTrue()
	self:TestReservedWord{'t','r','u','e'};
	
	return true;
end;

function JsonReader:ReadFalse()
	self:TestReservedWord{'f','a','l','s','e'};
	
	return false;
end;

function JsonReader:ReadNull()
	self:TestReservedWord{'n','u','l','l'};
	
	return nil;
end;

function JsonReader:TestReservedWord(t)
	for i, v in ipairs(t) do
		if (self:Next() ~= v) then
			error(string.format("Error reading '%s': %s", table.concat(t), self:All()));
		end;
	end;
end;

function JsonReader:ReadNumber()
	local result = self:Next();
	local peek = self:Peek();
	
	while peek ~= nil and string.find(peek, "[%+%-%d%.eE]") do
		result = result .. self:Next();
		peek = self:Peek();
	end;
	
	result = tonumber(result);
	
	if (result == nil) then
		error(string.format("Invalid number: '%s'", result));
	else
		return result;
	end;
end;

function JsonReader:ReadString()
	local result = "";
	
	assert(self:Next() == '"');
	
	while (self:Peek() ~= '"') do
		local ch = self:Next();
		
		if (ch == '\\') then
			ch = self:Next();
			if (self.escapes[ch]) then
				ch = self.escapes[ch];
			end;
		end;
		
		result = result .. ch;
	end;
	
	assert(self:Next() == '"');
	
	local fromunicode = function(m)
		return string.char(tonumber(m, 16));
	end;
	
	return string.gsub(result, "u%x%x(%x%x)", fromunicode);
end;

function JsonReader:ReadComment()
	assert(self:Next() == '/');
	
	local second = self:Next();
	
	if (second == '/') then
		self:ReadSingleLineComment();
	elseif (second == '*') then
		self:ReadBlockComment();
	else
		error(string.format("Invalid comment: %s", self:All()));
	end;
end;

function JsonReader:ReadBlockComment()
	local done = false;
	
	while (!done) do
		local ch = self:Next();
		
		if (ch == '*' and self:Peek() == '/') then
			done = true;
		end;
		
		if (!done and ch == '/' and self:Peek() == "*") then
			error(string.format("Invalid comment: %s, '/*' illegal.",  self:All()));
		end;
	end;
	
	self:Next();
end;

function JsonReader:ReadSingleLineComment()
	local ch = self:Next();
	
	while (ch ~= '\r' and ch ~= '\n') do
		ch = self:Next();
	end;
end;

function JsonReader:ReadArray()
	local result = {};
	
	assert(self:Next() == '[');
	
	local done = false;
	
	if (self:Peek() == ']') then
		done = true;
	end;
	
	while (!done) do
		local item = self:Read();
		result[#result + 1] = item;
		
		self:SkipWhiteSpace();
		
		if (self:Peek() == ']') then
			done = true;
		end;
		
		if (!done) then
			local ch = self:Next();
			if (ch ~= ',') then
				error(string.format("Invalid array: '%s' due to: '%s'", self:All(), ch));
			end;
		end;
	end;
	
	assert(']' == self:Next());
	
	return result;
end;

function JsonReader:ReadObject()
	local result = {};
	
	assert(self:Next() == '{');
	
	local done = false;
	local amt = 0;
	
	if self:Peek() == '}' then
		done = true;
	end;
	
	while (!done) do
		local key = self:Read();
		
		if type(key) ~= "string" then
			error(string.format("Invalid non-string object key: %s", key));
		end;
		
		self:SkipWhiteSpace();
		
		local ch = self:Next();
		
		if ch ~= ':' then
			error(string.format("Invalid object: '%s' due to: '%s'", self:All(), ch));
		end;
		
		self:SkipWhiteSpace();
		
		local val = self:Read();
		result[key] = val;
		amt = amt + 1;
		
		self:SkipWhiteSpace();
		
		if self:Peek() == '}' then
			done = true;
		end;
		
		if not done then
			ch = self:Next();
			
			if ch ~= ',' then
				error(string.format("Invalid array: '%s' near: '%s'", self:All(), ch));
			end;
		end;
	end;
	
	assert(self:Next() == "}");
	
	if (amt == 2) then
		if (result.x and result.y) then
			result = greenshell.vector:new(result.x, result.y);
		end;
	end;
	
	return result;
end;

function JsonReader:SkipWhiteSpace()
	local p = self:Peek();
	
	while p ~= nil and string.find(p, "[%s/]") do
		if p == '/' then
			self:ReadComment();
		else
			self:Next();
		end;
		
		p = self:Peek();
	end;
end;

function JsonReader:Peek()
	return self.reader:Peek();
end;

function JsonReader:Next()
	return self.reader:Next();
end;

function JsonReader:All()
	return self.reader:All();
end;

function Clockwork.json:Encode(tableToEncode)
	local writer = JsonWriter:New();
		writer:Write(tableToEncode);
	return writer:ToString();
end;

function Clockwork.json:Decode(stringToDecode)
	local reader = JsonReader:New(stringToDecode);
	
	return reader:Read();
end;

function Null()
	return Null;
end;
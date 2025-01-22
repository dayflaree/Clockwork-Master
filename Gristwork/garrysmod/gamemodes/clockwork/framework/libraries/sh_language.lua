
local Clockwork = Clockwork;
local pairs = pairs;
local type = type;
local string = string;

Clockwork.language = Clockwork.kernel:NewLibrary("Lang");
Clockwork.language.stored = Clockwork.language.stored or {};

-- A function to get a language string.
function Clockwork.language:GetPhrase(key, ...)
	local languageName = GetConVarString("gmod_language");

	if (!self.stored[languageName] or !self.stored[languageName][key]) then
		languageName = "en";
	end;

	if (self.stored[languageName] and self.stored[languageName][key]) then
		return string.format(self.stored[languageName][key], ...);
	else
		ErrorNoHalt("[Clockwork] There is no '"..key.."' language phrase!\n");
	end;
end;

-- A function to add a language string or table.
function Clockwork.language:Add(name, key, value)
	if (!self.stored[name]) then
		self.stored[name] = {};
	end;

	if (type(key) == "table") then
		for k, v in pairs(key) do
			self.stored[name][k] = v;
		end;
	elseif (type(key) == "string") then
		if (type(value) == "string") then
			self.stored[name][key] = value;
		end;
	end;
end;

-- A function to add language phrases by a file.
function Clockwork.language:AddByFile(name, filePath)
	if (file.Exists(filePath, "GAME")) then
		local languageTable = util.KeyValuesToTable(
			file.Read(filePath, "GAME")
		);

		return self:Add(name, languageTable);
	end;
end;

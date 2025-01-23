--[[
	Free Clockwork!
--]]

Clockwork.generator = Clockwork:NewLibrary("Generator");
Clockwork.generator.stored = {};

-- A function to register a new generator.
function Clockwork.generator:Register(name, power, health, maximum, cash, uniqueID, powerName, powerPlural)
	self.stored[uniqueID] = {
		powerPlural = powerPlural or powerName or "Power",
		powerName = powerName or "Power",
		uniqueID = uniqueID,
		maximum = maximum or 5,
		health = health or 100,
		power = power or 2,
		cash = cash or 100,
		name = name
	};
end;

-- A function to get all generators.
function Clockwork.generator:GetAll()
	return self.stored;
end;

-- A function to get a generator by its name.
function Clockwork.generator:Get(name)
	if (!self.stored[name]) then
		local generator = nil;
		
		for k, v in pairs(self.stored) do
			if (string.find(string.lower(v.name), string.lower(name))) then
				if (!generator or string.len(v.name) < string.len(generator.name)) then
					generator = v;
				end;
			end;
		end;
		
		return generator;
	else
		return self.stored[name];
	end;
end;
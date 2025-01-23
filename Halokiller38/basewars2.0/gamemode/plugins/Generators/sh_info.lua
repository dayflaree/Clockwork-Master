--==============
--	Generators
--==============
local PLUGIN = PLUGIN;

RP.generator = {};
RP.generator.stored = {};
RP.generator.max = 2;
RP.generator.interval = 900;
RP.generator.upgradeCost = 500;
RP.generator.upgradeTime = 30;

PLUGIN.name = "Generator";

function RP.generator:New(data)
	if (data.uniqueID) then
		self.stored[data.uniqueID] = data;
	else
		MsgN("Failed to create generator, missing unique ID");
	end;
end;

function RP.generator:Get(data)
	if (self.stored[data]) then
		return self.stored[data];
	else
		for k,v in pairs(self.stored) do
			if (v.name == data) then
				return v;
			end;
		end;
	end;
end;

local GENERATOR = {};
GENERATOR.name = "Basic Generator";
GENERATOR.payAmount = 100;
GENERATOR.startEnergy = 100
GENERATOR.energyLoss = 30;
GENERATOR.model = "models/props_combine/combine_mine01.mdl";
GENERATOR.uniqueID = "gen_basic";
RP.generator:New(GENERATOR);

local GENERATOR = {};
GENERATOR.name = "Advanced Generator";
GENERATOR.payAmount = 180;
GENERATOR.startEnergy = 150;
GENERATOR.energyLoss = 30;
GENERATOR.model = "models/props_combine/combine_mine01.mdl";
GENERATOR.uniqueID = "gen_advanced";
RP.generator:New(GENERATOR);

local GENERATOR = {};
GENERATOR.name = "Master Generator";
GENERATOR.payAmount = 260;
GENERATOR.startEnergy = 200;
GENERATOR.energyLoss = 30;
GENERATOR.model = "models/props_combine/combine_mine01.mdl";
GENERATOR.uniqueID = "gen_master";
RP.generator:New(GENERATOR);

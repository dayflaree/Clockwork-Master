--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Ukranian Military Uniform";
ITEM.weight = 5;
ITEM.iconModel = "models/MW2/SKIN_12/mw2_soldier_04.mdl";
ITEM.protection = 0.4;
ITEM.description = "A tactical uniform with a Ukranian Military insignia on the sleeve.";
ITEM.replacement = "models/MW2/SKIN_12/mw2_soldier_04.mdl";
ITEM.pocketSpace = 10;
ITEM.radProtect = 0.2;

openAura.item:Register(ITEM);
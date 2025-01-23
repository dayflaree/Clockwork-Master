--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Spetsnaz Uniform";
ITEM.weight = 7;
ITEM.iconModel = "models/Half-Dead/Modern Spetsnaz/male_11.mdl";
ITEM.protection = 0.6;
ITEM.description = "A tactical uniform with a Spetsnaz insignia on the sleeve.";
ITEM.replacement = "models/Half-Dead/Modern Spetsnaz/male_11.mdl";
ITEM.pocketSpace = 8;
ITEM.radProtect = 0.4;

openAura.item:Register(ITEM);
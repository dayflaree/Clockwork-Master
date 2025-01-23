--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "ammo_base";
ITEM.cost = 500;
ITEM.name = ".357 Rounds";
ITEM.batch = 1;
ITEM.model = "models/stalker/ammo/9x18.mdl";
ITEM.weight = 0.35;
ITEM.business = true;
ITEM.access = "T";
ITEM.uniqueID = "ammo_357";
ITEM.ammoClass = "357";
ITEM.ammoAmount = 8;
ITEM.description = "An green container with some ammunation inside.";

openAura.item:Register(ITEM);
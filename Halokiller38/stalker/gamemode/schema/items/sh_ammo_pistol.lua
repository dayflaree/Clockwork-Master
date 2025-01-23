--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "ammo_base";
ITEM.cost = 450;
ITEM.name = "9x19mm Rounds";
ITEM.batch = 1;
ITEM.model = "models/stalker/ammo/9x19.mdl";
ITEM.weight = 0.8;
ITEM.business = true;
ITEM.access = "T";
ITEM.uniqueID = "ammo_pistol";
ITEM.ammoClass = "pistol";
ITEM.ammoAmount = 24;
ITEM.description = "An average sized green container with 9mm on the side.";

openAura.item:Register(ITEM);
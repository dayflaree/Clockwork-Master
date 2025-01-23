--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "ammo_base";
ITEM.cost = 1000;
ITEM.name = "7.65x59mm Rounds";
ITEM.batch = 1;
ITEM.model = "models/stalker/ammo/762x54.mdl";
ITEM.weight = 0.35;
ITEM.business = true;
ITEM.access = "T";
ITEM.uniqueID = "ammo_sniper";
ITEM.ammoClass = "ar2";
ITEM.ammoAmount = 8;
ITEM.description = "A green container with some 7.65x59mm inside.";

openAura.item:Register(ITEM);
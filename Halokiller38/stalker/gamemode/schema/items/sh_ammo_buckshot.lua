--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "ammo_base";
ITEM.cost = 500;
ITEM.name = "Buckshot Rounds";
ITEM.batch = 1;
ITEM.model = "models/items/boxbuckshot.mdl";
ITEM.weight = 0.5;
ITEM.business = true;
ITEM.access = "T";
ITEM.uniqueID = "ammo_buckshot";
ITEM.ammoClass = "buckshot";
ITEM.ammoAmount = 12;
ITEM.description = "A small red box filled with Buckshot on the side.";

openAura.item:Register(ITEM);
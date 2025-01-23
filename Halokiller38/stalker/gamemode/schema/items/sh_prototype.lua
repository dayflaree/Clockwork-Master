--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "stalker_base";
ITEM.cost = 45000;
ITEM.name = "Heavy Prototype Exo-Skeleton Armor";
ITEM.weight = 1;
ITEM.business = false;
ITEM.armorScale = 1;
ITEM.replacement = "models/stalkertnb/dave_exo.mdl";
ITEM.description = "A Heavy Prototype Exo-Skeleton Armor.";

openAura.item:Register(ITEM);
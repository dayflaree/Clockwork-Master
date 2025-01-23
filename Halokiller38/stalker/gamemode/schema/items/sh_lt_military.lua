--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "military_base";
ITEM.cost = 9000;
ITEM.name = "Lieutenant Military Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.50;
ITEM.replacement = "models/stalkertnb/skat_merc.mdl";
ITEM.description = "A Lieutenant Military Armor. Gives 50% Bullet Protection";

openAura.item:Register(ITEM);
--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "military_base";
ITEM.cost = 7500;
ITEM.name = "Sergeant Military Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.50;
ITEM.replacement = "models/stalkertnb/skat_mili.mdl";
ITEM.description = "A Sergeant Military Armor. Gives 50% Bullet Protection";

openAura.item:Register(ITEM);
--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "military_base";
ITEM.cost = 20000;
ITEM.name = "General Military Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.65;
ITEM.replacement = "models/stalkertnb/beri_mili.mdl";
ITEM.description = "A Captain Military Armor. Gives 65% Bullet Protection";

openAura.item:Register(ITEM);
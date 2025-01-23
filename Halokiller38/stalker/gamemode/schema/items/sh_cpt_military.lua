--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "military_base";
ITEM.cost = 12000;
ITEM.name = "Captain Military Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.55;
ITEM.replacement = "models/stalkertnb/skat_duty.mdl";
ITEM.description = "A Captain Military Armor. Gives 55% Bullet Protection";

openAura.item:Register(ITEM);
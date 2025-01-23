--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "military_base";
ITEM.cost = 5000;
ITEM.name = "Recruit Military Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.45;
ITEM.replacement = "models/stalkertnb/skat_spet.mdl";
ITEM.description = "A Recruit Military Armor. Gives 45% Bullet Protection";

openAura.item:Register(ITEM);
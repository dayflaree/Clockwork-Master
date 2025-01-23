--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "monolith_base";
ITEM.cost = 7500;
ITEM.name = "Experienced Monolith Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.50;
ITEM.replacement = "models/stalkertnb/psz9d_mono3.mdl";
ITEM.description = "A Experienced Monolith Armor. Gives 50% Bullet Protection";

openAura.item:Register(ITEM);
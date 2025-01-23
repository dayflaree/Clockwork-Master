--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "monolith_base";
ITEM.cost = 5000;
ITEM.name = "Rookie Monolith Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.45;
ITEM.replacement = "models/stalkertnb/psz9d_mono4.mdl";
ITEM.description = "A Rookie Monolith Armor. Gives 45% Bullet Protection";

openAura.item:Register(ITEM);
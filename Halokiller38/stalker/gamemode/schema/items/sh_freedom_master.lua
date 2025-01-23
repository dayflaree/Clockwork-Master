--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "freedom_base";
ITEM.cost = 12000;
ITEM.name = "Master Freedom Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.55;
ITEM.replacement = "models/stalkertnb/psz9d_free.mdl";
ITEM.description = "A Master Freedom Armor. Gives 55% Bullet Protection";

openAura.item:Register(ITEM);
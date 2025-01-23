--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "freedom_base";
ITEM.cost = 7500;
ITEM.name = "Experienced Freedom Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.50;
ITEM.replacement = "models/stalkertnb/psz9d_free3.mdl";
ITEM.description = "A Experienced Freedom Armor. Gives 50% Bullet Protection";

openAura.item:Register(ITEM);
--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "freedom_base";
ITEM.cost = 9000;
ITEM.name = "Veteran Freedom Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.50;
ITEM.replacement = "models/stalkertnb/psz9d_free2.mdl";
ITEM.description = "A Veteran Freedom Armor. Gives 50% Bullet Protection";

openAura.item:Register(ITEM);
--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "elite_freedom_base";
ITEM.cost = 20000;
ITEM.name = "Elite Freedom Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.65;
ITEM.replacement = "models/stalkertnb/exo_free.mdl";
ITEM.description = "A Heavy Freedom Armor. Gives 65% Bullet Protection";

openAura.item:Register(ITEM);
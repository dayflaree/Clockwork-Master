--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "elite_monolith_base";
ITEM.cost = 20000;
ITEM.name = "Elite Monolith Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.65;
ITEM.replacement = "models/stalkertnb/exo_mono.mdl";
ITEM.description = "A Heavy Elite Monolith Armor. Gives 65% Bullet Protection";

openAura.item:Register(ITEM);
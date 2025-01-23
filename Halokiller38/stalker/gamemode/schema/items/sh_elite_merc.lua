--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "mercenarie_base";
ITEM.cost = 20000;
ITEM.name = "Elite Mercenarie Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.65;
ITEM.replacement = "models/stalkertnb/exo_merc.mdl";
ITEM.description = "A Heavy Elite Mercenarie Armor. Gives 65% Bullet Protection";

openAura.item:Register(ITEM);
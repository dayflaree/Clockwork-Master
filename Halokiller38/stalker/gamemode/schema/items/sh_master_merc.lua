--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "mercenarie_base";
ITEM.cost = 12000;
ITEM.name = "Master Mercenarie Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.55;
ITEM.replacement = "models/stalkertnb/io7a_merc1.mdl";
ITEM.description = "A Master Mercenarie Armor. Gives 55% Bullet Protection";

openAura.item:Register(ITEM);
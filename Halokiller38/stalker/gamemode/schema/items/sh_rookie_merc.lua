--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "mercenarie_base";
ITEM.cost = 5000;
ITEM.name = "Rookie Mercenarie Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.45;
ITEM.replacement = "models/stalkertnb/io7a_merc2.mdl";
ITEM.description = "A Rookie Mercenarie Armor. Gives 45% Bullet Protection";

openAura.item:Register(ITEM);
--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Heavy Tactical Gasmask Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.67;
ITEM.replacement = "models/stalkertnb/io7a_merc7.mdl";
ITEM.description = "A Heavy Tactical Gasmask Armor. Gives 67% Bullet Protection";

openAura.item:Register(ITEM);
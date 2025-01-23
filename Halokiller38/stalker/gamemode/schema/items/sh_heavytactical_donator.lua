--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Heavy Tactical Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.655;
ITEM.replacement = "models/stalkertnb/cs1_lone.mdl";
ITEM.description = "A Heavy Tactical Armor. Gives 65.5% Bullet Protection";

openAura.item:Register(ITEM);
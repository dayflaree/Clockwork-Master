--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "clothes_base";
ITEM.name = "Exo Bear 9000";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.75;
ITEM.replacement = "models/stalkertnb/exobear9000.mdl";
ITEM.description = "A Heavy Exo Bear 9000. Gives 75% Bullet Protection";

openAura.item:Register(ITEM);
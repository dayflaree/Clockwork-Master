--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "duty_base";
ITEM.cost = 5000;
ITEM.name = "Rookie Duty Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.45;
ITEM.replacement = "models/stalkertnb/psz9d_duty4.mdl";
ITEM.description = "A Rookie Duty armor, gives about 45% Bullet Protection.";

openAura.item:Register(ITEM);
--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "duty_base";
ITEM.cost = 8500;
ITEM.name = "Experienced Duty Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.50;
ITEM.replacement = "models/stalkertnb/psz9d_duty3.mdl";
ITEM.description = "A Experienced Duty Armor. Gives 50% Bullet Protection";

openAura.item:Register(ITEM);
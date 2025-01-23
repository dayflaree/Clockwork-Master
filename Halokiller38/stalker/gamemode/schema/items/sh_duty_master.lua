--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "duty_base";
ITEM.cost = 12000;
ITEM.name = "Master Duty Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.55;
ITEM.replacement = "models/stalkertnb/psz9d_duty.mdl";
ITEM.description = "A Master Duty Armor. Gives 55% Bullet Protection";

openAura.item:Register(ITEM);
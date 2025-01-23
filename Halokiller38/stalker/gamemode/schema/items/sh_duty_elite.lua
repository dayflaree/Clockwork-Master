--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "elite_duty_base";
ITEM.cost = 20000;
ITEM.name = "Elite Duty Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.65;
ITEM.replacement = "models/stalkertnb/exo_duty.mdl";
ITEM.description = "A Heavy Elite Duty Armor. Gives 65% Bullet Protection";

openAura.item:Register(ITEM);
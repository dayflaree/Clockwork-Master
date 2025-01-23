--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "bandit_base";
ITEM.cost = 12000;
ITEM.name = "Elite Bandit Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.35;
ITEM.replacement = "models/stalkertnb/bandit6.mdl";
ITEM.description = "A Elite Bandit Cloak. Gives 30% Bullet Protection";

openAura.item:Register(ITEM);
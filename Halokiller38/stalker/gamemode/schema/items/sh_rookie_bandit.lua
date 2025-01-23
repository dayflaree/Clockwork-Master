--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "bandit_base";
ITEM.cost = 5000;
ITEM.name = "Rookie Bandit Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.25;
ITEM.replacement = "models/stalkertnb/bandit4.mdl";
ITEM.description = "A Rookie Bandit Cloak. Gives 25% Bullet Protection";

openAura.item:Register(ITEM);
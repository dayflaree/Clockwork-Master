--[[
	� 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "bandit_base";
ITEM.cost = 9000;
ITEM.name = "Master Bandit Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.35;
ITEM.replacement = "models/stalkertnb/bandit1.mdl";
ITEM.description = "A Master Bandit Cloak. Gives 30% Bullet Protection";

openAura.item:Register(ITEM);
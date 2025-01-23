--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "bandit_base";
ITEM.cost = 20000;
ITEM.name = "Leader Bandit Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.armorScale = 0.40;
ITEM.replacement = "models/stalkertnb/banditboss3.mdl";
ITEM.description = "A Elite Bandit Cloak. Gives 40% Bullet Protection";

openAura.item:Register(ITEM);
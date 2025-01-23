--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "elite_stalker_base";
ITEM.cost = 20000;
ITEM.name = "Elite S.T.A.L.K.E.R Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.access = "T";
ITEM.armorScale = 0.65;
ITEM.replacement = "models/stalkertnb/exo_lone.mdl";
ITEM.description = "A Master Freedom Armor. Gives 65% Bullet Protection";

openAura.item:Register(ITEM);
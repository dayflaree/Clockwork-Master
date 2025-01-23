--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "stalker_base";
ITEM.cost = 12000;
ITEM.name = "Master S.T.A.L.K.E.R Armor";
ITEM.weight = 1;
ITEM.business = true;
ITEM.access = "T";
ITEM.armorScale = 0.55;
ITEM.replacement = "models/stalkertnb/psz9d_ecologist1.mdl";
ITEM.description = "A Master S.T.A.L.K.E.R Armor. Gives 55% Bullet Protection";

openAura.item:Register(ITEM);
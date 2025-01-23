--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "bio_base";
ITEM.cost = 4000;
ITEM.name = "S.T.A.L.K.E.R Bio Suit";
ITEM.weight = 1;
ITEM.business = true;
ITEM.access = "T";
ITEM.armorScale = 0.355;
ITEM.replacement = "models/stalkertnb/rad_ecol.mdl";
ITEM.description = "An Anti-rad bio suit. That gives 35.5% Bullet Protection";

openAura.item:Register(ITEM);
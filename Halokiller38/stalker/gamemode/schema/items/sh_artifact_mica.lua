--[[
	� 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "artifact_base";
ITEM.cost = 10000;
ITEM.name = "Mica";
ITEM.model = "models/srp/items/art_mica.mdl";
ITEM.batch = 1;
ITEM.weight = 0.9;
ITEM.access = "T";
ITEM.business = false;
ITEM.category = "Artifacts"
ITEM.description = "An Artifact That is really hard to see.";
ITEM.meleeWeapon = false;
ITEM.isAttachment = false;

openAura.item:Register(ITEM);
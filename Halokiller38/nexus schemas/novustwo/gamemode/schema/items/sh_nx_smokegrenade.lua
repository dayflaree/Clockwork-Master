--[[
Name: "sh_nx_smokegrenade.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "grenade_base";
ITEM.cost = 40;
ITEM.name = "AN-M18";
ITEM.model = "models/items/grenadeammo.mdl";
ITEM.batch = 1;
ITEM.weight = 0.3;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "nx_smokegrenade";
ITEM.description = "A dusty tube with something engraved on to it.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(90, 180, 0);
ITEM.attachmentOffsetVector = Vector(0, 6.55, 8.72);

nexus.item.Register(ITEM);
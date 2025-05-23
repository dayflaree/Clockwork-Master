--[[
Name: "sh_nx_flaregrenade.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "grenade_base";
ITEM.name = "Flare";
ITEM.model = "models/items/grenadeammo.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "nx_flaregrenade";
ITEM.description = "A dirty tube of dust, is this supposed to be a grenade?";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
ITEM.attachmentOffsetVector = Vector(0, 6.55, 8.72);

nexus.item.Register(ITEM);
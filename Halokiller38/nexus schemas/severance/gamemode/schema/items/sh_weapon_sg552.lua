--[[
Name: "sh_weapon_sg552.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "SG-552";
ITEM.model = "models/weapons/w_rif_sg552.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "rcs_sg552";
ITEM.description = "A moderately sized assault rifle with a scope.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

nexus.item.Register(ITEM);
--[[
Name: "sh_weapon_m3super90.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "M3 Super 90";
ITEM.model = "models/weapons/w_shot_m3super90.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "weapon_m3super90";
ITEM.weaponClass = "rcs_m3";
ITEM.description = "A moderately sized weapon coated in a dull grey.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

nexus.item.Register(ITEM);
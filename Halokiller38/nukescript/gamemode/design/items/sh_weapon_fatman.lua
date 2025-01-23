--[[
Name: "sh_weapon_m4a1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 500000;
ITEM.name = "Fatman";
ITEM.model = "models/weapons/w_fatman.mdl";
ITEM.weight = 20;
ITEM.uniqueID = "fo3_fatman";
ITEM.weaponClass = "fo3_fatman";
ITEM.description = "A large green fatman (Mini nukes not included.)\nThis firearm requires Mini Nukes.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = false;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
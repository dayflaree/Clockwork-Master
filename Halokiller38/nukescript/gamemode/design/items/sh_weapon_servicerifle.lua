--[[
Name: "sh_weapon_m4a1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 25000;
ITEM.name = "Service Rifle";
ITEM.model = "models/weapons/w_rif_m4a1.mdl";
ITEM.weight = 3;
ITEM.uniqueID = "weapon_servicerifle";
ITEM.weaponClass = "rcs_custom_assaultrifle";
ITEM.description = "An NCR issued Rifle with a shiny tint.\nThis firearm utilises 5.56x45mm ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
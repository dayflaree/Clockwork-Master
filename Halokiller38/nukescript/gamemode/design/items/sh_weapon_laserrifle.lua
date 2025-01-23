--[[
Name: "sh_weapon_m4a1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 4000;
ITEM.name = "Laser Rifle";
ITEM.model = "models/weapons/w_laserrifle.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "fo3_laserrifle";
ITEM.weaponClass = "weapon_laserrifle";
ITEM.description = "A chipped yellow laser rifle.\nThis rifle utilises Energy Cells.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
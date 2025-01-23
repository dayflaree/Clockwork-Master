--[[
Name: "sh_weapon_m4a1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 8000;
ITEM.name = "Combat Shotgun";
ITEM.model = "models/weapons/w_combatshotgun.mdl";
ITEM.weight = 5;
ITEM.uniqueID = "fo3_combatshotgun";
ITEM.weaponClass = "fo3_combatshotgun";
ITEM.description = "A wooden and metal combat shotgun \nThis firearm requires buckshot ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = false;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
--[[
Name: "sh_weapon_deagle.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 7000;
ITEM.name = "Desert Eagle";
ITEM.model = "models/weapons/w_pist_deagle.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "rcs_deagle";
ITEM.description = "A well designed silver pistol.\nThis firearm utilises .357 ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

blueprint.item.Register(ITEM);
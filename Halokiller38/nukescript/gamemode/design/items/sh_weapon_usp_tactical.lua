--[[
Name: "sh_weapon_usp_tactical.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 1250;
ITEM.name = "USP-T";
ITEM.model = "models/weapons/w_pist_usp.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "rcs_usp";
ITEM.description = "A light grey pistol with a suppressor.\nThis firearm utilises 9x19mm ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

blueprint.item.Register(ITEM);
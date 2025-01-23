--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 11000;
ITEM.name = "SVT-40";
ITEM.model = "models/weapons/w_garanb.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "weapon_sim_TokarevSVT-40";
ITEM.weaponClass = "weapon_sim_TokarevSVT-40";
ITEM.description = "A fairly new SVT-40 supplied by the Red Army\nThis firearm utilizes 7.62 rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
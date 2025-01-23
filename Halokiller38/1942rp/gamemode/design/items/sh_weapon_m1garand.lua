--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 11000;
ITEM.name = "M1 Garand";
ITEM.model = "models/weapons/w_garand_f.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "weapon_sim_M1Garand";
ITEM.weaponClass = "weapon_sim_M1Garand";
ITEM.description = "A fairly new M1 Garand supplied by the US Army\nThis firearm utilizes 7.62 rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
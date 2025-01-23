--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 11000;
ITEM.name = "FG42";
ITEM.model = "models/weapons/w_mp33.mdl";
ITEM.weight = 6;
ITEM.uniqueID = "weapon_sim_fg42";
ITEM.weaponClass = "weapon_sim_fg42";
ITEM.description = "A new FG42 supplied by the Wehrmacht\nThis firearm utilizes 7.92 rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
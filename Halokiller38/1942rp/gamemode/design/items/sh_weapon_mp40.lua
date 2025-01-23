--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 11000;
ITEM.name = "MP40";
ITEM.model = "models/weapons/w_mp40_n.mdl";
ITEM.weight = 6;
ITEM.uniqueID = "weapon_sim_mp40";
ITEM.weaponClass = "weapon_sim_mp40";
ITEM.description = "A new MP40 supplied by the Wehrmacht\nThis firearm utilizes 9mm rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
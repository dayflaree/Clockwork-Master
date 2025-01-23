--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 200000;
ITEM.name = "MG42";
ITEM.model = "models/weapons/w_mg42bd_f.mdl";
ITEM.weight = 6;
ITEM.uniqueID = "weapon_sim_mg42";
ITEM.weaponClass = "weapon_sim_mg42";
ITEM.description = "A new MG42 supplied by the Wehrmacht\nThis firearm utilizes 7.92mm rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
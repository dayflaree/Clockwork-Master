--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 3000;
ITEM.name = "P38";
ITEM.model = "models/weapons/w_p38_f.mdl";
ITEM.weight = 6;
ITEM.uniqueID = "weapon_sim_p38";
ITEM.weaponClass = "weapon_sim_p38";
ITEM.description = "A new P38 supplied by the Wehrmacht\nThis firearm utilizes 9mm rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
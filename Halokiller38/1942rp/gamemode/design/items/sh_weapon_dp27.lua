--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 20000;
ITEM.name = "DP-27";
ITEM.model = "models/weapons/w_D0cal.mdl";
ITEM.weight = 6;
ITEM.uniqueID = "weapon_sim_dp30";
ITEM.weaponClass = "weapon_sim_dp30";
ITEM.description = "A new DP-27 supplied by the Red Army\nThis firearm utilizes 7.62mm rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
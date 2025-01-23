--[[
Name: "sh_weapon_ak47.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 11000;
ITEM.name = "PPsH 41";
ITEM.model = "models/weapons/w_ppsh1941.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "weapon_sim_ppsh41";
ITEM.weaponClass = "weapon_sim_ppsh41";
ITEM.description = "A new PPsH 41 supplied by the Red Army\nThis firearm utilizes 7.62 Pistol rounds.";
ITEM.isAttachment = false;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";

blueprint.item.Register(ITEM);
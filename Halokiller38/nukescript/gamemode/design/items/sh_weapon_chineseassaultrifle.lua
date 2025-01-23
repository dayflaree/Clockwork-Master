--[[
Name: "sh_weapon_m4a1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 13000;
ITEM.name = "Chinese Assault Rifle";
ITEM.model = "models/weapons/w_rif_ak47.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "fo3_chinese_assault_rifle";
ITEM.weaponClass = "fo3_chinese_assault_rifle";
ITEM.description = "A fairly old Chinese Assault Rifle. \nThis firearm requires 5.56x45mm ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = false;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
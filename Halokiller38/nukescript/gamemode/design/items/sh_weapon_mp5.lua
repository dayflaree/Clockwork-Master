--[[
Name: "sh_weapon_mp5.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 7000;
ITEM.name = "MP5";
ITEM.model = "models/weapons/w_smg_mp5.mdl";
ITEM.weight = 2.5;
ITEM.uniqueID = "weapon_mp5";
ITEM.weaponClass = "rcs_mp5";
ITEM.description = "A compact sub-machine firearm a dirty exterior.\nThis firearm utilises 9x19mm ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
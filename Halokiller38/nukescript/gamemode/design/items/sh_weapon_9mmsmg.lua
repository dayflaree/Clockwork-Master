--[[
Name: "sh_weapon_m4a1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 9000;
ITEM.name = "9mm SMG";
ITEM.model = "models/weapons/w_smg_mp5.mdl";
ITEM.weight = 3;
ITEM.uniqueID = "weapon_9mmsmg";
ITEM.weaponClass = "rcs_smg9mm";
ITEM.description = "An old 9mm SMG with a rusted tint.\nThis firearm utilises 9x19mm ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
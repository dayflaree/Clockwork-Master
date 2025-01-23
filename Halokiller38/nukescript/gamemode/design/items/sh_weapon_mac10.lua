--[[
Name: "sh_weapon_mac10.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 6000;
ITEM.name = "MAC-10";
ITEM.model = "models/weapons/w_smg_mac10.mdl";
ITEM.batch = 1;
ITEM.weight = 1.5;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "weapon_mac10";
ITEM.weaponClass = "rcs_mac10";
ITEM.description = "A dirty inaccurate firearm with grey coloring.\nThis firearm utilises 9x19mm ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

blueprint.item.Register(ITEM);
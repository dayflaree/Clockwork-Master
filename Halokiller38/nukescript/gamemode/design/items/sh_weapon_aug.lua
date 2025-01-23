--[[
Name: "sh_weapon_aug.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 10000;
ITEM.name = "AUG";
ITEM.model = "models/weapons/w_rif_aug.mdl";
ITEM.weight = 3;
ITEM.uniqueID = "rcs_aug";
ITEM.description = "A scoped firearm with a light tan.\nThis firearm utilises 5.56x45mm ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
--[[
Name: "sh_weapon_famas.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 12000;
ITEM.name = "Famas";
ITEM.model = "models/weapons/w_rif_famas.mdl";
ITEM.weight = 3;
ITEM.uniqueID = "rcs_famas";
ITEM.description = "An average sized grey rifle with a big magazine.\nThis firearm utilises 5.56x45mm ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(20, 70, 15);
ITEM.attachmentOffsetVector = Vector(10, 0, -8);

blueprint.item.Register(ITEM);
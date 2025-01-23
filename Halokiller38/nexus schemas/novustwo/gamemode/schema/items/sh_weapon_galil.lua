--[[
Name: "sh_weapon_galil.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 525;
ITEM.name = "Galil";
ITEM.model = "models/weapons/w_rif_galil.mdl";
ITEM.weight = 3;
ITEM.uniqueID = "rcs_galil";
ITEM.description = "An averaged sized firearm with an orange tint.\nThis firearm utilises 5.56x45mm ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(20, 70, 15);
ITEM.attachmentOffsetVector = Vector(10, 0, -8);

nexus.item.Register(ITEM);
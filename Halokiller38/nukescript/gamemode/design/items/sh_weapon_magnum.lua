--[[
Name: "sh_weapon_magnum.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 3000;
ITEM.name = "Magnum";
ITEM.model = "models/weapons/w_357.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "rcs_magnum";
ITEM.description = "An extremely powerful silver pistol.\nThis firearm utilises .357 ammunition.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

blueprint.item.Register(ITEM);
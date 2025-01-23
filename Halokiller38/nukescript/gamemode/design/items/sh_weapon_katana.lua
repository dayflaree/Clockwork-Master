--[[
Name: "sh_weapon_katana.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 900;
ITEM.name = "Katana";
ITEM.model = "models/weapons/w_katana.mdl";
ITEM.weight = 1.25;
ITEM.uniqueID = "bp_katana";
ITEM.category = "Melee";
ITEM.description = "A katana made by the Japanese that can dice up anything.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(90, 180, 20);
ITEM.attachmentOffsetVector = Vector(0, 6, 0);

blueprint.item.Register(ITEM);
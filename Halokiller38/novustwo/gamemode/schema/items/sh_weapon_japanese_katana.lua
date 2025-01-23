--[[
Name: "sh_weapon_japanese_katana.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 150;
ITEM.name = "Japanese Katana";
ITEM.model = "models/weapons/w_katana.mdl";
ITEM.weight = 1.25;
ITEM.uniqueID = "nx_japanesekatana";
ITEM.category = "Melee";
ITEM.description = "A katana made by the Japanese that can dice up anything.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(90, 180, 20);
ITEM.attachmentOffsetVector = Vector(0, 6, 0);

nexus.item.Register(ITEM);
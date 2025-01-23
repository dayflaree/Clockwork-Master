--[[
Name: "sh_weapon_sledge_hammer.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 130;
ITEM.name = "Sledge Hammer";
ITEM.model = "models/weapons/w_sledgehammer.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "nx_sledgehammer";
ITEM.category = "Melee";
ITEM.description = "This beast can tear through anything.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, 0);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

nexus.item.Register(ITEM);
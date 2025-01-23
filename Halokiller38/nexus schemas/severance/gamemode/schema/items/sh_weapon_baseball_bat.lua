--[[
Name: "sh_weapon_baseball_bat.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "Baseball Bat";
ITEM.model = "models/weapons/w_basball.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "nx_baseballbat";
ITEM.category = "Melee";
ITEM.description = "A fairly large baseball bat - it isn't shiny anymore.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(90, 180, 20);
ITEM.attachmentOffsetVector = Vector(0, 7, 0);

nexus.item.Register(ITEM);
--[[
Name: "sh_weapon_baseball_bat.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 500;
ITEM.name = "Baseball Bat";
ITEM.model = "models/weapons/w_basball.mdl";
ITEM.batch = 1;
ITEM.weight = 0.75;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "bp_baseballbat";
ITEM.category = "Melee";
ITEM.description = "A fairly large baseball bat. It isn't shiny anymore.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(90, 180, 20);
ITEM.attachmentOffsetVector = Vector(0, 6, 0);

blueprint.item.Register(ITEM);
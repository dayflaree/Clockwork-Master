--[[
Name: "sh_weapon_baseball_bat.lua".
Product: "Phase Four".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Baseball Bat";
ITEM.cost = 11;
ITEM.access = "L";
ITEM.business = true;
ITEM.model = "models/weapons/w_basball.mdl";
ITEM.weight = 1;
ITEM.category = "Melee";
ITEM.weaponClass = "aura_baseballbat";
ITEM.description = "A fairly large baseball bat. It isn't shiny anymore.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(90, 180, 20);
ITEM.attachmentOffsetVector = Vector(0, 7, 0);

openAura.item:Register(ITEM);
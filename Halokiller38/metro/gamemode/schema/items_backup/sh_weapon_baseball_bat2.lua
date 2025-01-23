--[[
Name: "sh_weapon_baseball_bat.lua".
Product: "Phase Four".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Shiny Baseball Bat";
ITEM.cost = 30;
ITEM.access = "4";
ITEM.business = true;
ITEM.model = "models/weapons/w_basebat.mdl";
ITEM.weight = 1;
ITEM.category = "Melee";
ITEM.weaponClass = "aura_baseballbat2";
ITEM.description = "A fairly large baseball bat.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(90, 180, 20);
ITEM.attachmentOffsetVector = Vector(0, 7, 0);

openAura.item:Register(ITEM);
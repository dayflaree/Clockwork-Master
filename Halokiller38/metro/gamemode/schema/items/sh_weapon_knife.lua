--[[
Name: "sh_weapon_knife.lua".
Product: "Phase Four".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Knife";
ITEM.model = "models/maver1k_XVII/metro_machete.mdl";
ITEM.plural = "Knives";
ITEM.weight = 0.75;
ITEM.cost = 15;
ITEM.access = "L";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.category = "Melee";
ITEM.weaponClass = "aura_knife";
ITEM.description = "A compact metal knife good for jibbing up humans.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-18, -5, 5);
ITEM.loweredAngles = Angle(-10, 10, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(20, 0, -90);
ITEM.attachmentOffsetVector = Vector(2, -2, 8);

openAura.item:Register(ITEM);
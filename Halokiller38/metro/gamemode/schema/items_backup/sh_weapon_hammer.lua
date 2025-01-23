--[[
Name: "sh_weapon_baseball_bat.lua".
Product: "Phase Four".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Hammer";
ITEM.cost = 20;
ITEM.access = "y";
ITEM.business = true;
ITEM.model = "models/weapons/w_hammer.mdl";
ITEM.weight = 1;
ITEM.category = "Melee";
ITEM.weaponClass = "aura_hammer";
ITEM.description = "It isn't shiny anymore.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(63.53, 0, -83.38);
ITEM.attachmentOffsetVector = Vector(5.88, 14.71, 6.62);

openAura.item:Register(ITEM);
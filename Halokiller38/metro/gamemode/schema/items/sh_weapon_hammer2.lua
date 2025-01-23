--[[
Name: "sh_weapon_baseball_bat.lua".
Product: "Phase Four".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Rusty Hammer";
ITEM.cost = 20;
ITEM.access = "y";
ITEM.business = true;
ITEM.model = "models/weapons/w_hammerr.mdl";
ITEM.weight = 1;
ITEM.category = "Melee";
ITEM.weaponClass = "aura_hammer";
ITEM.description = "It isn't shiny anymore.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-7.94, 33.09, -180);
ITEM.attachmentOffsetVector = Vector(0, 8.09, 7.35);

openAura.item:Register(ITEM);
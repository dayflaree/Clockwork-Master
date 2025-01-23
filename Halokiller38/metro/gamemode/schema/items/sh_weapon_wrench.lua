--[[
Name: "sh_weapon_baseball_bat.lua".
Product: "Phase Four".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Wrench tool";
ITEM.cost = 1;
ITEM.access = "y";
ITEM.business = true;
ITEM.model = "models/weapons/w_wrench.mdl";
ITEM.weight = 1;
ITEM.category = "Melee";
ITEM.weaponClass = "aura_wrench";
ITEM.description = "It isn't shiny anymore.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-63.53, 93.97, -83.38);
ITEM.attachmentOffsetVector = Vector(75.74, 41.18, 7.35);

openAura.item:Register(ITEM);
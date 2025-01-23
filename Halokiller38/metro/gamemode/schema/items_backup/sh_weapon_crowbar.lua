--[[
Name: "sh_weapon_crowbar.lua".
Product: "Phase Four".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Crowbar";
ITEM.model = "models/weapons/w_crowbar.mdl";
ITEM.weight = 1;
ITEM.cost = 11;
ITEM.access = "L";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.category = "Melee";
ITEM.weaponClass = "aura_crowbar";
ITEM.description = "A scratched up and dirty metal crowbar.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-18, -5, 5);
ITEM.loweredAngles = Angle(-10, 10, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(200, 200, 0);
ITEM.attachmentOffsetVector = Vector(0, 5, 2);

openAura.item:Register(ITEM);
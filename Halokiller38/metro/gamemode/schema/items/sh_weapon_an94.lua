--[[
Name: "sh_weapon_m4a1.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "AN94";
ITEM.model = "models/weapons/w_rif_an94.mdl";
ITEM.weight = 3;
ITEM.cost = 200;
ITEM.access = "4";
ITEM.business = true;
ITEM.uniqueID = "weapon_an94";
ITEM.weaponClass = "rcs_an94";
ITEM.description = "A smooth black weapon with a shiny tint.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

openAura.item:Register(ITEM);
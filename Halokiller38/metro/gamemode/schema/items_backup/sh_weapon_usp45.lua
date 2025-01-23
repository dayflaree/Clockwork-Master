--[[
Name: "sh_weapon_usp45.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "USP .45";
ITEM.model = "models/weapons/w_pist_usp.mdl";
ITEM.weight = 1;
ITEM.cost = 35;
ITEM.access = "L";
ITEM.business = true;
ITEM.uniqueID = "rcs_usp";
ITEM.description = "A small, light grey pistol with a silencer attachment.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

openAura.item:Register(ITEM);
--[[
Name: "sh_weapon_ak47.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Black AK-103";
ITEM.model = "models/weapons/w_ak103.mdl";
ITEM.weight = 3;
ITEM.cost = 60;
ITEM.access = "H";
ITEM.business = true;
ITEM.uniqueID = "weapon_ak103";
ITEM.weaponClass = "rcs_ak47";
ITEM.description = "A grey and brown weapon with rust on the side.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

openAura.item:Register(ITEM);
--[[
Name: "sh_weapon_galil.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Bastard";
ITEM.model = "models/weapons/w_mp40.mdl";
ITEM.weight = 3;
ITEM.cost = 30;
ITEM.access = "H";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "aura_bastard";
ITEM.description = "A long grey and orange weapon with decent accuracy.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

openAura.item:Register(ITEM);
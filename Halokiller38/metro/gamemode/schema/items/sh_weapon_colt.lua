--[[
Name: "sh_weapon_p228.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Colt 1911";
ITEM.model = "models/weapons/w_191145.mdl";
ITEM.weight = 1.5;
ITEM.cost = 28;
ITEM.access = "4";
ITEM.business = true;
ITEM.uniqueID = "rcs_colt";
ITEM.description = "A small, dark grey pistol.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

openAura.item:Register(ITEM);
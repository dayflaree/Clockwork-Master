--[[
Name: "sh_weapon_deagle.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "1985 Deagle";
ITEM.model = "models/weapons/w_pist_deagle.mdl";
ITEM.weight = 1.5;
ITEM.cost = 76;
ITEM.access = "4";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "rcs_1985deagle";
ITEM.description = "An old rusty deagle.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

openAura.item:Register(ITEM);
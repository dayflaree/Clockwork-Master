--[[
Name: "sh_weapon_galil.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "base_rifle";
ITEM.name = "SCAR";
ITEM.model = "models/weapons/w_rif_scar.mdl";
ITEM.weight = 3;
ITEM.cost = 89;
ITEM.access = "H";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "weapon_scar";
ITEM.description = "A long grey weapon with decent accuracy.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

openAura.item:Register(ITEM);
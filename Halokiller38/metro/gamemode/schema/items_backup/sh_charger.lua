--[[
Name: "sh_weapon_famas.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Universal Battery Charger";
ITEM.model = "models/avoxgaming/mrp/jake/props/universal_charger.mdl";
ITEM.weight = 0.75;
ITEM.cost = 50;
ITEM.access = "H";
ITEM.business = true;
ITEM.uniqueID = "aura_batterycharger";
ITEM.description = "A chunky charger that fits into anything.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = false;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(0, 0, 90);
ITEM.attachmentOffsetVector = Vector(0, 4, -8);


openAura.item:Register(ITEM);
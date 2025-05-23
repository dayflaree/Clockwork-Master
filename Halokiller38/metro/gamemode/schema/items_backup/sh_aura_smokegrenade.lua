--[[
Name: "sh_aura_smokegrenade.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "grenade_base";
ITEM.name = "Smoke";
ITEM.model = "models/items/grenadeammo.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "aura_smokegrenade";
ITEM.description = "A dirty tube of dust, is this supposed to be a grenade?";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
ITEM.attachmentOffsetVector = Vector(0, 6.55, 8.72);
ITEM.cost = 10;
ITEM.access = "A";
ITEM.business = true;

openAura.item:Register(ITEM);
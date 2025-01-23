--[[
Name: "sh_weapon_357.lua".
Product: "HL2 RP".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = ".357 Magnum";
ITEM.cost = 95;
ITEM.access = "L";
ITEM.model = "models/weapons/W_357.mdl";
ITEM.weight = 2;
ITEM.uniqueID = "weapon_357";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.description = "A small pistol, the coated silver is rusting away.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

openAura.item:Register(ITEM);
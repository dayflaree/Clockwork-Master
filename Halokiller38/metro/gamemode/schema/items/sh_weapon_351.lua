--[[
Name: "sh_weapon_357.lua".
Product: "HL2 RP".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = ".351 Magnum";
ITEM.cost = 105;
ITEM.access = "4";
ITEM.model = "models/weapons/W_351.mdl";
ITEM.weight = 2;
ITEM.uniqueID = "rcs_351";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.description = "A long pistol, the coated silver is rusting away.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

openAura.item:Register(ITEM);
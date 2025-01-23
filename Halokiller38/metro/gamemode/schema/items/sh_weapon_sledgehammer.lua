--[[
Name: "sh_weapon_sledgehammer.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Sledgehammer";
ITEM.model = "models/weapons/w_sledgehammer.mdl";
ITEM.weight = 2.5;
ITEM.cost = 25;
ITEM.access = "L";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "aura_sledgehammer";
ITEM.category = "Melee";
ITEM.description = "This beast can tear through anything.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, 0);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

openAura.item:Register(ITEM);
--[[
Name: "sh_roleplay_smokegrenade.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "grenade_base";
ITEM.name = "Smoke";
ITEM.cost = 25;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.model = "models/items/grenadeammo.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "roleplay_smokegrenade";
ITEM.business = true;
ITEM.description = "A dirty tube of dust, is this supposed to be a grenade?";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
ITEM.attachmentOffsetVector = Vector(0, 6.55, 8.72);

resistance.item.Register(ITEM);
--[[
Name: "sh_weapon_aug.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 500000;
ITEM.name = "Alien Blaster";
ITEM.model = "models/weapons/w_alienpistol.mdl";
ITEM.weight = 2;
ITEM.uniqueID = "fo3_alienblaster";
ITEM.description = "An out of world weapon.\nThis firearm utilises Alien Power Cells.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
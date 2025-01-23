--[[
Name: "sh_weapon_metal_shovel.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "Metal Shovel";
ITEM.model = "models/weapons/w_shovel.mdl";
ITEM.weight = 2;
ITEM.uniqueID = "nx_metalshovel";
ITEM.category = "Melee";
ITEM.description = "A metal shovel, it is really heavy and powerful.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, 0);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

nexus.item.Register(ITEM);
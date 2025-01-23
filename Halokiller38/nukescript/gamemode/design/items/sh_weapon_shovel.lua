--[[
Name: "sh_weapon_shovel.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 500;
ITEM.name = "Shovel";
ITEM.model = "models/weapons/w_shovel.mdl";
ITEM.weight = 1.25;
ITEM.uniqueID = "bp_shovel";
ITEM.category = "Melee";
ITEM.description = "A metal shovel, it is really heavy and powerful.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, 0);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

blueprint.item.Register(ITEM);
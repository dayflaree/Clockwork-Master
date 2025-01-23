--[[
Name: "sh_weapon_usp_match.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 100000;
ITEM.name = "Flamer";
ITEM.model = "models/weapons/w_flamer.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "fo3_flamer";
ITEM.description = "A large flamethrower.\nIt uses flamer fuel, not cheap stuff.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.loweredOrigin = Vector(5, -4, -3);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(0, 0, 90);
ITEM.attachmentOffsetVector = Vector(0, 4, -8);

blueprint.item.Register(ITEM);
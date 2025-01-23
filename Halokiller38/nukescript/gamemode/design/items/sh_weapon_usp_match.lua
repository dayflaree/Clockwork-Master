--[[
Name: "sh_weapon_usp_match.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 900;
ITEM.name = "10mm Pistol";
ITEM.model = "models/weapons/w_10mmpistol.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "rcs_uspmatch";
ITEM.description = "A large, 10mm pistol.\nThis firearm utilises 9x19mm ammunition.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.loweredOrigin = Vector(5, -4, -3);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(0, 0, 90);
ITEM.attachmentOffsetVector = Vector(0, 4, -8);

blueprint.item.Register(ITEM);
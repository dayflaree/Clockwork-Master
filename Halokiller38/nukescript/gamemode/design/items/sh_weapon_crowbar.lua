--[[
Name: "sh_weapon_crowbar.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 650;
ITEM.name = "Crowbar";
ITEM.model = "models/weapons/w_crowbar.mdl";
ITEM.batch = 1;
ITEM.weight = 1;
ITEM.access = "T";
ITEM.uniqueID = "bp_crowbar";
ITEM.category = "Melee";
ITEM.business = true;
ITEM.description = "A scratched up and dirty metal crowbar.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-18, -5, 5);
ITEM.loweredAngles = Angle(-10, 10, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(200, 200, 0);
ITEM.attachmentOffsetVector = Vector(0, 5, 2);

blueprint.item.Register(ITEM);
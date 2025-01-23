--[[
Name: "sh_weapon_woodaxe.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 500;
ITEM.name = "Woodaxe";
ITEM.model = "models/weapons/w_axe.mdl";
ITEM.weight = 0.9;
ITEM.uniqueID = "bp_woodaxe";
ITEM.category = "Melee";
ITEM.description = "An old unreliable wooden axe - it could do some damage.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, 0);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

blueprint.item.Register(ITEM);
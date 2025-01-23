--[[
Name: "sh_weapon_wooden_axe.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "Wooden Axe";
ITEM.model = "models/weapons/w_axe.mdl";
ITEM.weight = 1.5;
ITEM.uniqueID = "nx_woodenaxe";
ITEM.category = "Melee";
ITEM.description = "An old unreliable wooden axe - it could do some damage.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, 0);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

nexus.item.Register(ITEM);
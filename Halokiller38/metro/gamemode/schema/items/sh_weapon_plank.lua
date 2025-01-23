--[[
Name: "sh_weapon_plank.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Plank";
ITEM.model = "models/weapons/w_plank.mdl";
ITEM.weight = 1;
ITEM.cost = 3;
ITEM.access = "L";
ITEM.worth = 1;
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "aura_plank";
ITEM.category = "Melee";
ITEM.description = "A heavy wooden plank with some nails in the end.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, -90);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

openAura.item:Register(ITEM);
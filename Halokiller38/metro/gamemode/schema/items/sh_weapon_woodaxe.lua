--[[
Name: "sh_weapon_woodaxe.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Woodaxe";
ITEM.model = "models/weapons/w_axe.mdl";
ITEM.weight = 1.5;
ITEM.cost = 10;
ITEM.access = "L";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "aura_woodaxe";
ITEM.category = "Melee";
ITEM.description = "An old unreliable wooden axe - it could do some damage.";
ITEM.meleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 255, 0);
ITEM.attachmentOffsetVector = Vector(5, 5, -8);

openAura.item:Register(ITEM);
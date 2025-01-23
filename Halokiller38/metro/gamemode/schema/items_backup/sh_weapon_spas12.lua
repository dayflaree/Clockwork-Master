--[[
Name: "sh_weapon_spas12.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "SV10";
ITEM.model = "models/weapons/w_sv10.mdl";
ITEM.weight = 4;
ITEM.cost = 80;
ITEM.access = "H";
ITEM.business = true;
ITEM.uniqueID = "weapon_spas12";
ITEM.weaponClass = "rcs_spas12";
ITEM.description = "A nicely shaped, dark grey and scratched up weapon.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

openAura.item:Register(ITEM);
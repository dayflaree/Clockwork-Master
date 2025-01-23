--[[
Name: "sh_weapon_m249.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "PKM";
ITEM.model = "models/weapons/w_pkm.mdl";
ITEM.weight = 4;
ITEM.cost = 160;
ITEM.access = "H";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "weapon_m249";
ITEM.weaponClass = "rcs_m249";
ITEM.description = "A very big machine gun - usually attached to a barricade.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.loweredAngles = Angle(-10, 40, -40);
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

openAura.item:Register(ITEM);
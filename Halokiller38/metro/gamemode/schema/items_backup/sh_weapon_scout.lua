--[[
Name: "sh_weapon_scout.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "SVT40";
ITEM.model = "models/weapons/w_svt40.mdl";
ITEM.weight = 4;
ITEM.cost = 130;
ITEM.access = "H";
ITEM.business = true;
ITEM.hasFlashlight = true;
ITEM.uniqueID = "weapon_scout";
ITEM.weaponClass = "rcs_scout";
ITEM.description = "A long grey sniper rifle for attacking at long range distances.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

openAura.item:Register(ITEM);
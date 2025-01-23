--[[
Name: "sh_weapon_scout.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "Scout";
ITEM.model = "models/weapons/w_snip_scout.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "weapon_scout";
ITEM.weaponClass = "rcs_scout";
ITEM.description = "A long grey sniper rifle for attacking at long range distances.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

nexus.item.Register(ITEM);
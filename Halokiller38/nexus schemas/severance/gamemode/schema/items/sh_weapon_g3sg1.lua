--[[
Name: "sh_weapon_g3sg1.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "G3SG1";
ITEM.model = "models/weapons/w_snip_g3sg1.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "rcs_g3sg1";
ITEM.description = "A long black, silenced sniper rifle for attacking at long range distances.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

nexus.item.Register(ITEM);
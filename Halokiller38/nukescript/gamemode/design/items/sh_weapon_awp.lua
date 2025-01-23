--[[
Name: "sh_weapon_awp.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 35000;
ITEM.name = "Anti-Material Rifle";
ITEM.model = "models/weapons/w_snip_awp.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "rcs_awp";
ITEM.description = "A fairly new sniper rifle with a metallic side.\nThis firearm utilises 7.65x59mm ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

blueprint.item.Register(ITEM);
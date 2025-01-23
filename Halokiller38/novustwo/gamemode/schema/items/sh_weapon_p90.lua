--[[
Name: "sh_weapon_p90.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 450;
ITEM.name = "FN P90";
ITEM.model = "models/weapons/w_smg_p90.mdl";
ITEM.weight = 3;
ITEM.uniqueID = "rcs_p90";
ITEM.description = "A grey firearm with a large magazine.\nThis firearm utilises 5.7x28mm ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

nexus.item.Register(ITEM);
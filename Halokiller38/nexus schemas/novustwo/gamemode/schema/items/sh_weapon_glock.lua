--[[
Name: "sh_weapon_glock.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 200;
ITEM.name = "Glock";
ITEM.model = "models/weapons/w_pist_glock18.mdl";
ITEM.batch = 1;
ITEM.weight = 1.5;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "weapon_glock";
ITEM.weaponClass = "rcs_glock";
ITEM.description = "A dirty pistol with a plastic coating.\nThis firearm utilises 9x19mm ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

nexus.item.Register(ITEM);
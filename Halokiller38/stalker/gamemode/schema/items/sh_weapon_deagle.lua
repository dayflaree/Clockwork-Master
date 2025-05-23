--[[
	� 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "weapon_base";
ITEM.name = "Desert Eagle";
ITEM.cost = 1800;
ITEM.model = "models/weapons/w_pist_deagle.mdl";
ITEM.weight = 1.5;
ITEM.business = true;
ITEM.access = "T";
ITEM.weaponClass = "rcs_deagle";
ITEM.description = "A well designed silver pistol.\nThis firearm utilises .357 ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(-180, 180, 90);
ITEM.attachmentOffsetVector = Vector(-4.19, 0, -8.54);

openAura.item:Register(ITEM);
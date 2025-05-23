--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("custom_weapon");
ITEM.name = "FN P90";
ITEM.cost = 3500;
ITEM.model = "models/weapons/w_smg_p90.mdl";
ITEM.weight = 3;
ITEM.business = true;
ITEM.batch = 1;
ITEM.access = "V";
ITEM.weaponClass = "rcs_p90";
ITEM.description = "A grey firearm with a large magazine.\nThis firearm utilises 5.7x28mm ammunition.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

Clockwork.item:Register(ITEM);
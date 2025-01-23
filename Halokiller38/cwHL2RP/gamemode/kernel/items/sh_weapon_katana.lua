--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("custom_weapon");
ITEM.name = "Katana";
ITEM.cost = 1000;
ITEM.model = "models/weapons/w_katana.mdl";
ITEM.weight = 1.25;
ITEM.business = true;
ITEM.batch = 1;
ITEM.access = "v";
ITEM.category = "Melee";
ITEM.weaponClass = "cw_katana";
ITEM.description = "A long japanese blade designed for slicing.";
ITEM.isMeleeWeapon = true;
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(-12, 2, 0);
ITEM.loweredAngles = Angle(-25, 15, -80);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(90, 180, 20);
ITEM.attachmentOffsetVector = Vector(0, 6, 0);

Clockwork.item:Register(ITEM);
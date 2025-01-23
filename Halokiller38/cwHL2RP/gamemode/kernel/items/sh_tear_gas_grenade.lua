--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New("grenade_base");
ITEM.name = "Tear Gas Grenade";
ITEM.cost = 150;
ITEM.model = "models/items/grenadeammo.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "cw_teargasgrenade";
ITEM.business = true;
ITEM.batch = 1;
ITEM.access = "O";
ITEM.description = "A dirty tube of dust, is this supposed to be a grenade?";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(90, 180, 0);
ITEM.attachmentOffsetVector = Vector(0, 6.55, 8.72);

Clockwork.item:Register(ITEM);
	
	local ITEM = Clockwork.item:New( "special_weapon" );
	ITEM.name = "Shovel";
	ITEM.spawnValue = 2;
	ITEM.spawnType = "misc";
	ITEM.uniqueID = "cw_shovel";
	ITEM.category = "Melee Weapons";
	ITEM.cost = 50;
	ITEM.model = "models/weapons/w_shovel.mdl";
	ITEM.weight = 3;
	ITEM.business = true;
	ITEM.isMeleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine4";
	ITEM.access = "Mv";
	ITEM.attachmentOffsetAngles = Angle(100, 100, 100);
	ITEM.attachmentOffsetVector = Vector(4, 3, 1);
	ITEM.attachmentModelScale = Vector(1, 1, 0.9);
	ITEM.description = "An aged shovel with a wrotting handle.  The end of the shovel is clearly worn and scratched.";

	ITEM:Register();
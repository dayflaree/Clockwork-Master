	
	local ITEM = Clockwork.item:New( "special_weapon" );
	ITEM.name = "Baseball Bat";
	ITEM.spawnValue = 4;
	ITEM.spawnType = "misc";
	ITEM.uniqueID = "cw_baseballbat";
	ITEM.category = "Melee Weapons";
	ITEM.cost = 50;
	ITEM.model = "models/weapons/w_basball.mdl";
	ITEM.weight = 2;
	ITEM.business = true;
	ITEM.isMeleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Hand";
	ITEM.attachmentOffsetAngles = Angle(0, 270, 0);
	ITEM.attachmentOffsetVector = Vector(4, 1, 3);
	ITEM.access = "Mv";
	ITEM.description = "An old baseball bat with the signature of a baseball player inscribed on it.";

	ITEM:Register();
	
	local ITEM = Clockwork.item:New( "special_weapon" );
	ITEM.name = "Axe";
	ITEM.spawnValue = 2;
	ITEM.spawnType = "misc";
	ITEM.uniqueID = "cw_woodaxe";
	ITEM.category = "Melee Weapons";
	ITEM.cost = 100;
	ITEM.model = "models/weapons/w_axe.mdl";
	ITEM.weight = 2.5;
	ITEM.business = true;
	ITEM.isMeleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(5, 90, 290);
	ITEM.attachmentOffsetVector = Vector(-4, 0, 23);
	ITEM.access = "Mv";
	ITEM.description = "An old axe with a slightly wrotten wooden handle. The blade is still sharp.";

	ITEM:Register();
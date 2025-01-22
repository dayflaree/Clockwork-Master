	
	local ITEM = Clockwork.item:New( "special_weapon" );
	ITEM.name = "Sledgehammer";
	ITEM.uniqueID = "cw_sledgehammer";
	ITEM.spawnValue = 2;
	ITEM.spawnType = "misc";
	ITEM.category = "Melee Weapons";
	ITEM.cost = 100;
	ITEM.model = "models/weapons/w_sledgehammer.mdl";
	ITEM.weight = 4;
	ITEM.business = true;
	ITEM.isMeleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Hand";
	ITEM.attachmentOffsetVector = Vector(-22, 1, 4);
	ITEM.access = "Mv";
	ITEM.description = "An old, heavy Sledgehammer with a wrotting wooden handle.  It is flimsy and decaying.";
	
	ITEM:Register();
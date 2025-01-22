local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Hopper Mine";
	ITEM.cost = 120;
	ITEM.category = "Deployables";
	ITEM.model = "models/props_combine/combine_mine01.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "weapon_hopper";
	ITEM.weaponClass = "cw_mineswep";
	ITEM.business = false;
	ITEM.description = "A powerful, compact mine, utilizing pneumatically-powered legs to propel itself at nearby personnel.";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "Bone08_T";
	
	-- A function to get whether the attachment is visible.
	function ITEM:GetAttachmentVisible(player, entity)
		if (player:HasWeapon(self("weaponClass")) and player:GetModel() == "models/shield_scanner.mdl") then
			return true;
		end;
	end;
ITEM:Register();
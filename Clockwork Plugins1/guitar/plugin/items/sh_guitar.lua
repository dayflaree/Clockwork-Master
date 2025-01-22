local ITEM = Clockwork.item:New("special_weapon");

ITEM.name = "Guitar";
ITEM.cost = 0;
ITEM.model = "models/acoustic guitar/acousticguitar.mdl";
ITEM.weight = 4;
ITEM.uniqueID = "cw_guitar";
ITEM.isRareSpawn = true;
ITEM.spawnValue = 1;
ITEM.isMeleeWeapon = true;
ITEM.business = false;
ITEM.category = "Reusables";
ITEM.description = "A wooden acoustic guitar in a somewhat good condition.";
ITEM.isAttachment = true;

ITEM.attachmentBone = "ValveBiped.Bip01_R_Hand";
ITEM.attachmentOffsetAngles = Angle(100, 270, 10);
ITEM.attachmentOffsetVector = Vector(0, 15, 0);

ITEM:AddData("Rarity", 3);

-- A function to get whether the attachment is visible.
function ITEM:GetAttachmentVisible(player, entity)
	return (Clockwork.player:GetWeaponClass(player) == self("weaponClass"));
end;

--[[ Called when a player attempts to drop the weapon.
function ITEM:CanDropWeapon(player, attacker, bNoMsg)
	if (player:GetActiveWeapon().Song != nil) then
		if (player:GetActiveWeapon().Song:IsPlaying()) then
			Clockwork.player:Notify(player, "You cannot drop the guitar while playing!");
			
			return false;
		end;
	end;
	
	return true;
end;

-- Called when a player attempts to holster the weapon.
function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	if (player:GetActiveWeapon().Song != nil) then
		if (player:GetActiveWeapon().Song:IsPlaying()) then
			Clockwork.player:Notify(player, "You cannot holster the guitar while playing!");
			
			return false;
		end;
	end;
	
	return true;
end;]]--

ITEM:Register();
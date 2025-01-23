--[[
Name: "sv_hooks.lua".
Product: "eXperim3nt".
--]]

local MOUNT = MOUNT;

-- Called when a player uses an item.
function MOUNT:PlayerUseItem(player, itemTable)
	--if (itemTable.category == "Consumables" or itemTable.category == "Alcohol") then
	--	player:SetCharacterData("radiation", 100);
	--end;
end;

-- Called when a player's character data should be saved.
function MOUNT:PlayerSaveCharacterData(player, data)
	if ( data["radiation"] ) then
		data["radiation"] = math.Round( data["radiation"] );
	end;
end;

-- Called when a player's character data should be restored.
function MOUNT:PlayerRestoreCharacterData(player, data)
	data["radiation"] = data["radiation"] or 0;
end;

-- Called just after a player spawns.
function MOUNT:PostPlayerSpawn(player, lightSpawn)
	if (lightSpawn) then
		player:SetCharacterData("radiation", 0);
	end;
end;

-- Called when a player's shared variables should be set.
function MOUNT:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "sh_Radiation", math.Round( player:GetCharacterData("radiation") ) );
end;

-- Called at an interval while a player is connected.
function MOUNT:PlayerThink(player, curTime, infoTable)
	if (!player:Alive()) then return end
	if ( player:Alive() and player:Health() >= 1) then
		local radiation = player:GetSharedVar("sh_Radiation");
		//local radiation = player:GetCharacterData("radiation")
		if (radiation >= 500 and radiation <= 800) then
			local current = player:Health()
			player:SetHealth( current - 1 )
		elseif (radiation >= 800) then
			local current = player:Health()
			player:SetHealth( current - 2 )
		elseif (radiation >= 1000) then
			if ( player:Alive() ) then
				player:Kill(); ragdoll = player:GetRagdollEntity();
				player:SetCharacterData("radiation", 0);
				player:UpdateAttribute(ATB_STRENGTH, -3);
				player:UpdateAttribute(ATB_AGILITY, -3);
			end;
		end
	else
		player:Kill(); ragdoll = player:GetRagdollEntity();
		player:SetCharacterData("radiation", 0);
		player:UpdateAttribute(ATB_STRENGTH, -3);
		player:UpdateAttribute(ATB_AGILITY, -3);
	end;
end

--[[
Name: "sv_auto.lua".
Product: "Skeleton".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if ( data["stamina"] ) then
		data["stamina"] = math.Round( data["stamina"] );
	end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["stamina"] = data["stamina"] or 100;
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!firstSpawn and !lightSpawn) then
		player:SetCharacterData("stamina", 100);
	end;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "sh_Stamina", math.Round( player:GetCharacterData("stamina") ) );
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local maximum = 100;
	
	if (infoTable.running or infoTable.jogging) then
		local carrying = (resistance.inventory.GetMaximumWeight(player) / 100) * resistance.inventory.GetWeight(player);
		local decrease = 3 + (carrying / 40) + ( 1 - (math.min(player:Health(), 100) / 100) );
		
		if (jogging) then
			decrease = decrease / 2;
		end;
		
		player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") - decrease, 0, maximum) );
		
		if (player:GetCharacterData("stamina") > 1) then
			if (infoTable.running) then
				player:ProgressAttribute(ATB_STAMINA, 0.125, true);
			elseif (infoTable.jogging) then
				player:ProgressAttribute(ATB_STAMINA, 0.0625, true);
			end;
		end;
	elseif (player:GetVelocity():Length() == 0) then
		if ( player:Crouching() ) then
			player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") + 1 - ( 1 - (math.min(player:Health(), 100) / 100) ), 0, maximum) );
		else
			player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") + 0.5 - ( 0.5 - (math.min(player:Health(), 100) / 200) ), 0, maximum) );
		end;
	else
		player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") + 0.25 - ( 0.25 - (math.min(player:Health(), 100) / 400) ), 0, maximum) );
	end;
	
	if (player:GetCharacterData("stamina") <= 1) then
		infoTable.running = false;
		infoTable.jogging = false;
	end;
end;
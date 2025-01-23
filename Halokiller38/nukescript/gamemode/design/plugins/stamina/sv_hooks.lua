--[[
Name: "sv_hooks.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

-- Called when a player uses an item.
function PLUGIN:PlayerUseItem(player, itemTable)
	if (itemTable.category == "Consumables" or itemTable.category == "Alcohol") then
		player:SetCharacterData("stamina", 100);
	end;
	
	if (itemTable.uniqueID == "melon" or itemTable.uniqueID == "milk_jug"
	or itemTable.uniqueID == "milk_carton" or itemTable.uniqueID == "bottled_water"
	or itemTable.uniqueID == "large_soda") then
		player:BoostAttribute("Thirst", ATB_AGILITY, 30, 3600);
		player:BoostAttribute("Thirst", ATB_STAMINA, 30, 3600);
	end;
end;

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

-- Called when a player attempts to throw a punch.
function PLUGIN:PlayerCanThrowPunch(player)
	if (player:GetCharacterData("stamina") <= 10) then
		return false;
	end;
end;

-- Called when a player throws a punch.
function PLUGIN:PlayerPunchThrown(player)
	local attribute = blueprint.attributes.Fraction(player, ATB_STAMINA, 1.5, 0.25);
	local carrying = (blueprint.inventory.GetMaximumWeight(player) / 100) * blueprint.inventory.GetWeight(player);
	local decrease = ( 5 + (carrying / 5) ) / (1 + attribute);
	local maximum = 100;
	
	player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") - decrease, 0, maximum) );
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "sh_Stamina", math.Round( player:GetCharacterData("stamina") ) );
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local regeneration = 0;
	local maximum = 100;
	local health = player:Health();
	
	if ( infoTable.running or infoTable.jogging and !blueprint.player.IsNoClipping(player) ) then
		local attribute = blueprint.attributes.Fraction(player, ATB_STAMINA, 1, 0.25);
		local carrying = (blueprint.inventory.GetMaximumWeight(player) / 100) * blueprint.inventory.GetWeight(player);
		local decrease = ( 3 + (carrying / 40) + ( 1 - (math.min(player:Health(), 100) / 100) ) ) / (1 + attribute);
		
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
			regeneration = ( 0.5 - ( 0.5 - (math.min(health, 100) / 200) ) );
			
			if (regeneration > 0) then
				player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") + regeneration, 0, maximum) );
			end;
		else
			regeneration = ( 0.25 - ( 0.25 - (math.min(health, 100) / 400) ) );
			
			if (regeneration > 0) then
				player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") + regeneration, 0, maximum) );
			end;
		end;
	else
		regeneration = ( 0.125 - ( 0.125 - (math.min(health, 100) / 800) ) );
		
		if (regeneration > 0) then
			player:SetCharacterData( "stamina", math.Clamp(player:GetCharacterData("stamina") + regeneration, 0, maximum) );
		end;
	end;
	
	if (player:GetCharacterData("stamina") <= 1) then
		infoTable.running = false;
		infoTable.jogging = false;
	end;
end;
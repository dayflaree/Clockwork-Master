--[[
	Name: sv_hooks.lua.
	Author: TJjokerR.
--]]

local PLUGIN = PLUGIN;

-- Called when a player switches their flashlight on or off.
function PLUGIN:PlayerSwitchFlashlight(player, on)
	if ( on and !self:PlayerHasFlashlight(player) ) then
		return false;
	end;
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	if ( player:FlashlightIsOn() ) then
		if ( !self:PlayerHasFlashlight(player) or player:GetCharacterData("battery") <= 0 ) then
			player:Flashlight(false);
		elseif(!player._nextBattery or player._nextBattery < CurTime())then
			player._nextBattery = CurTime() + 15;
			
			player:SetCharacterData("battery", player:GetCharacterData("battery") - 1);
		end;
		
		if(player:GetCharacterData("battery") > 0 and player:GetCharacterData("battery") <= 10
		and (!player._flickerFlashLight or player._flickerFlashLight < CurTime()))then
			player._flickerFlashLight = CurTime() + (player:GetCharacterData("battery") <= 5 and 3 or 15);
			
			player:Flashlight(false);
		end;
	end;
end;

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if ( data["battery"] ) then
		data["battery"] = math.Round( data["battery"] );
	end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["battery"] = data["battery"] or 100;
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!firstSpawn and !lightSpawn) then
		player:SetCharacterData("battery", 100);
	end;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "sh_Battery", math.Round( player:GetCharacterData("battery") ) );
end;
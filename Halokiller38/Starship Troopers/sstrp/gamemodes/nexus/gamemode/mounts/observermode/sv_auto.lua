--[[
Name: "sv_auto.lua".
Product: "Nexus".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

-- A function to make a player exit observer mode.
function MOUNT:MakePlayerExitObserverMode(player)
	player.observerResetting = true;
	player:DrawWorldModel(true);
	player:DrawShadow(true);
	player:SetMoveType(player.observerMoveType or MOVETYPE_WALK);
	
	timer.Simple(FrameTime() * 0.5, function()
		if ( IsValid(player) ) then
			if (player.observerPosition) then
				player:SetPos(player.observerPosition);
			end;
			
			if (player.observerAngles) then
				player:SetEyeAngles(player.observerAngles);
			end;
			
			if (player.observerColor) then
				player:SetColor( unpack(player.observerColor) );
			end;
			
			player.observerResetting = nil;
			player.observerMoveType = nil;
			player.observerPosition = nil;
			player.observerAngles = nil;
			player.observerMode = nil;
		end;
	end);
end;

-- A function to make a player enter observer mode.
function MOUNT:MakePlayerEnterObserverMode(player)
	player.observerMoveType = player:GetMoveType();
	player.observerPosition = player:GetPos();
	player.observerAngles = player:EyeAngles();
	player.observerColor = { player:GetColor() };
	player.observerMode = true;
	
	player:SetMoveType(MOVETYPE_NOCLIP);
end;
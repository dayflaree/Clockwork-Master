--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when a player attempts to NoClip.
function PLUGIN:PlayerNoClip(player)
	Clockwork.player:RunClockworkCommand(player, "Observer");
	
	return false;
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	if (!player:InVehicle() and !player:IsRagdolled() and !player:IsBeingHeld()
	and player:Alive() and player:GetMoveType() == MOVETYPE_NOCLIP) then
		local r, g, b, a = player:GetColor();
		
		player:DrawWorldModel(false);
		player:DrawShadow(false);
		player:SetColor(r, g, b, 0);
	elseif (player.cwObserverMode) then
		if (!player.cwObserverReset) then
			PLUGIN:MakePlayerExitObserverMode(player)
		end;
	end;
end;
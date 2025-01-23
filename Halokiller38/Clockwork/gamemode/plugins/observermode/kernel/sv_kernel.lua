--[[
	Free Clockwork!
--]]

-- A function to make a player exit observer mode.
function PLUGIN:MakePlayerExitObserverMode(player)
	player.cwObserverReset = true;
	player:DrawWorldModel(true);
	player:DrawShadow(true);
	player:SetMoveType(player.cwObserverMoveType or MOVETYPE_WALK);
	player:SetMaterial("")
	
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player)) then
			if (player.cwObserverPos) then
				player:SetPos(player.cwObserverPos);
			end;
			
			if (player.cwObserverAng) then
				player:SetEyeAngles(player.cwObserverAng);
			end;
			
			if (player.cwObserverColor) then
				player:SetColor(unpack(player.cwObserverColor));
			end;
			
			player.cwObserverMoveType = nil;
			player.cwObserverReset = nil;
			player.cwObserverPos = nil;
			player.cwObserverAng = nil;
			player.cwObserverMode = nil;
		end;
	end);
end;

-- A function to make a player enter observer mode.
function PLUGIN:MakePlayerEnterObserverMode(player)
	player.cwObserverMoveType = player:GetMoveType();
	player.cwObserverPos = player:GetPos();
	player.cwObserverAng = player:EyeAngles();
	player.cwObserverColor = { player:GetColor() };
	player.cwObserverMode = true;
	player:SetMaterial("models/props_combine/portalball001_sheet")
	
	player:SetMoveType(MOVETYPE_NOCLIP);
end;
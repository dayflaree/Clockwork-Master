--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when a player's data stream info should be sent.
function PLUGIN:PlayerSendDataStreamInfo(player)
	if (#self.mapScenes > 0) then
		player.cwMapScene = self.mapScenes[math.random(1, #self.mapScenes)];
		
		if (player.cwMapScene) then
			Clockwork:StartDataStream(player, "MapScene", player.cwMapScene);
		end;
	end;
end;

-- Called when a player's visibility should be set up.
function PLUGIN:SetupPlayerVisibility(player)
	if (player.cwMapScene) then
		AddOriginToPVS(player.cwMapScene.position);
	end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	PLUGIN:LoadMapScenes();
end;
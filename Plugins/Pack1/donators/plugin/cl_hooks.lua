
-----------------------------------------------------

local PLUGIN = PLUGIN;

 -- Called when a player should show on the scoreboard.
function PLUGIN:PlayerShouldShowOnScoreboard(player)
	local clientFaction = Clockwork.Client:GetFaction();
	local playerFaction = player:GetFaction();
	
	if (playerFaction == clientFaction) then
		return;
	end;

	if (playerFaction == FACTION_ZOMBIE or playerFaction == FACTION_ANTLION or playerFaction == FACTION_ALIENGRUNT) then
		return false;
	end;
end;

-- Called when a player's typing display position is needed.
function PLUGIN:GetPlayerTypingDisplayPosition(player)
	local faction = player:GetFaction();
	
	if (faction == FACTION_ANTLION) then
		return player:GetPos() + Vector(0, 0, 65);
	end;
end;
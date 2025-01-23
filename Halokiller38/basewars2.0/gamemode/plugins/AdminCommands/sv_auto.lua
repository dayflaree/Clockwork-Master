local PLUGIN = PLUGIN;

function PLUGIN:PlayerDataLoaded(player)
	if (player:HasFlag("a")) then
		player:SetUserGroup("superadmin");
	end;
end;

function PLUGIN:PlayerLoadout(player)
	if (player:HasFlag("a") or player:HasFlag("t")) then
		player:Give("gmod_tool");
	end;
end;
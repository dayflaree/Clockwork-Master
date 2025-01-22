--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

local PLUGIN = PLUGIN;

concommand.Add("virgil1", function(player)
	if (Schema:PlayerIsCombine(player)) then
	player:EmitSound("evo/virgil_1.wav");
end;
end)

concommand.Add("virgil2", function(player)
	if (Schema:PlayerIsCombine(player)) then
	player:EmitSound("evo/virgil_2.wav")
end;
end)
--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

resource.AddFile("models/weapons/v_fists.mdl")
resource.AddFile("models/weapons/w_fists.mdl")

function SF.theme:Initialize()
	SF:ContentFolder("materials/sf_stranded");
end;

function SF.theme:PlayerLoadout(player)
	player:Give("sf_hands");
	player:Give("sf_tool");
	return false;
end;


local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local string = string;

Clockwork.datastream:Hook("EditNotes", function(player, data)
	player:SetCharacterData("NotesText", string.sub(data[1] or "", 0, 1000));
end);
local PLUGIN = PLUGIN;

function PLUGIN:PlayerCanSwitchCharacter(player, character)
	if(Clockwork.config:Get("char_lock"):Get() == true and !player:IsAdmin()) then
		Clockwork.player:Notify(player, "Character switching is disabled at this time.");
		return false;
	end;
end;
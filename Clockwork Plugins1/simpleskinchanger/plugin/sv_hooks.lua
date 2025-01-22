local PLUGIN = PLUGIN;

-- Called just after a player spawns.
function PLUGIN:GetPlayerDefaultSkin(player)
	local skins = player:GetCharacterData("Skins");
	local model = player:GetModel();
	
	--Reset the player skin so character changes don't mess anything up.
	--player:SetSkin(0); --0
	
	if( skins and skins[model] )then
			return tonumber(skins[model]);
	end;
end;
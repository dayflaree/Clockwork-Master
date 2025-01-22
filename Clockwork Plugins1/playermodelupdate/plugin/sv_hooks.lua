
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when a player's default skin is needed
function PLUGIN:GetPlayerDefaultSkin(player)
	-- Check for a player-adjustable skin first
	local toggleSkin = player:GetCharacterData("toggle_skin", {});
	toggleSkin = toggleSkin[player:GetModel()];
	if (toggleSkin) then
		return toggleSkin;
	end;
	-- Check for a personal skin
	local skin = player:GetCharacterData("skins", {});
	skin = skin[player:GetModel()];
	if (skin) then
		return skin;
	end;
	-- Check for a class skin
	local class = Clockwork.class:FindByID(player:Team());
	if (class and class.skin) then
		return class.skin;
	end;
	-- Check for a faction skin
	local faction = Clockwork.faction:FindByID(player:GetFaction());
	if (faction and faction.skin) then
		return faction.skin;
	end;
	-- No skin found so return nothing
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	player:SetBodyGroups();
	--player:SetPlayerScale();
end;

-- Called when the player's model has been changed
function PLUGIN:PlayerModelChanged(player, model)
	player:SetBodyGroups();
	--player:SetPlayerScale();
end;

local PLUGIN = PLUGIN;

-- Called whe the map entities are initialized.
function PLUGIN:InitPostEntity()
	--[[
		This is a silly way to prevent removing flags 
		that are only given manually.
	--]]
	for k, v in pairs(self.userGroups) do
		for i = 1, #v do
			local flag = string.sub(v, i, i);

			if (!string.find(self.reset, flag)) then
				self.reset = self.reset..flag;
			end;
		end;
	end;

	for k, v in pairs(self.donatorRanks) do
		for i = 1, #v do
			local flag = string.sub(v, i, i);

			if (!string.find(self.reset, flag)) then
				self.reset = self.reset..flag;
			end;
		end;
	end;
end;

-- Called when a player's data has loaded.
function PLUGIN:PlayerDataLoaded(player)
	local steamID = player:SteamID();

	http.Fetch(self.API.."/subscription/get/"..steamID, function(body, length, headers, code)
		local bSuccess, value = pcall(util.JSONToTable, body);
				
		if (bSuccess and value != nil) then
			if (value.steamid != steamID) then
				ErrorNoHalt("[Clockwork] The SteamID returned by the subscription API did not match!\n");
				return;
			end;

			if (value.active) then
				player.cwDonation = value.type;
				player.cwLastDonation = value.timestamp;
			end;
		end;
	end,
	function(errorText)
		ErrorNoHalt("[Clockwork] Subscription API: "..errorText.."\n");
	end);
end;

local function ASSIGN_FLAGS(player)
	local flagList = Clockwork.config:Get("default_flags"):Get();
	local userGroup = player:GetUserGroup();

	if (PLUGIN.userGroups[userGroup]) then
		flagList = flagList..PLUGIN.userGroups[userGroup];
	end;

	if (player.cwDonation and PLUGIN.donatorRanks[player.cwDonation]) then
		flagList = flagList..PLUGIN.donatorRanks[player.cwDonation];
	end;

	Clockwork.player:TakeFlags(player, PLUGIN.reset);
	Clockwork.player:GiveFlags(player, flagList);
end;

-- Called when a player's character has initialized.
function PLUGIN:PlayerCharacterInitialized(player)
	local flagList = Clockwork.config:Get("default_flags"):Get();
	local steamID = player:SteamID();
	local userGroup = player:GetUserGroup();

	if (!player.cwDonation) then
		http.Fetch(self.API.."/subscription/get/"..steamID, function(body, length, headers, code)
			local bSuccess, value = pcall(util.JSONToTable, body);
					
			if (bSuccess and value != nil) then
				if (value.steamid != steamID) then
					ErrorNoHalt("[Clockwork] The SteamID returned by the subscription API did not match!\n");
					return;
				end;

				if (value.active) then
					player.cwDonation = value.type;
					player.cwLastDonation = value.timestamp;
				end;

				ASSIGN_FLAGS(player);
			end;
		end,
		function(errorText)
			ErrorNoHalt("[Clockwork] Subscription API: "..errorText.."\n");
		end);
	else
		ASSIGN_FLAGS(player);
	end;
end;

local NAME_CASH = Clockwork.option:GetKey("name_cash");

-- Called when a player's character has loaded.
function PLUGIN:PlayerCharacterLoaded(player)
	if (player.cwDonation and player.cwLastDonation) then
		local iLastClaimTokens = player:GetData("LastClaimTokens");

		if (!iLastClaimTokens or iLastClaimTokens < player.cwLastDonation) then
			Clockwork.player:Notify(
				player, "Use the command /Claim"..string.gsub(NAME_CASH, "%s", "").." to claim your monthly Gold Member "..Clockwork.kernel:Pluralize(string.lower(NAME_CASH))
			);
		end;
	end;
end;

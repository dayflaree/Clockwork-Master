
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;
local CurTime = CurTime;

local math = math;
local Clamp = math.Clamp;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity() 
	self:LoadGasZones(); 
	self:LoadNoGasZones();
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
	local player = player;

	if ((!player.nextGasCheck or player.nextGasCheck < curTime)) then
		local faction = Clockwork.faction:FindByID(player:GetFaction());
		
		player.nextGasCheck = curTime + self.gasTickTime;

		-- Skip if noclipping or gas does not have to be calculated yet
		if (Clockwork.player:IsNoClipping(player) or !player:Alive() or faction.noGas) then 
			return; 
		end;

		local gasScale = 0;
		local playerPos = player:GetShootPos();
		-- Loop over all exclusion zones which cover most players, this avoids having to do a lot of checks to find who is in a gas zone
		local isNotInNoGasZone = true;
		for k2, noGasZone in pairs(self.noGasZones) do
			if (self:IsInBox(playerPos, noGasZone.minimum, noGasZone.maximum)) then
				isNotInNoGasZone = false;
				break;
			end;
		end;
		-- Check if a player is in a gas zone if he is not in an exclusion zone
		-- As gasZones is inversly sorted on scale, the highest scaled zone the player is in is the first that he is in
		if (isNotInNoGasZone) then
			for k2, gasZone in ipairs(self.gasZones) do
				if (self:IsInBox(playerPos, gasZone.minimum, gasZone.maximum)) then
					gasScale = gasZone.scale;
					break;
				end;
			end;
		end;

		-- Player is in a gas zone
		if (gasScale > 0) then
			local playerGasDamageScale = 1;
			local clothes = player:GetClothesItem();
			-- Check for a gasmask
			if (clothes and clothes("hasRebreather")) then
				playerGasDamageScale = 0;
			elseif ((clothes and clothes("hasGasmask")) or player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_MPF) then
				local filterQuality = player:GetCharacterData("filterQuality");
				local filterScale = Clockwork.config:Get("gas_filter_scale"):Get();
				local filterDecrease = gasScale * self.gasTickTime * filterScale;
				-- Enough filter left for this tick
				if (filterQuality >= filterDecrease) then
					player:SetCharacterData("filterQuality", filterQuality - filterDecrease);
					playerGasDamageScale = 0;
					-- Filter left but not enough for this tick
				elseif (filterQuality > 0) then
					player:SetCharacterData("filterQuality", 0);
					-- Scale protection received based on how much was still left
					playerGasDamageScale = Clamp(filterQuality / filterDecrease, 0, 1);
					Clockwork.player:Notify(player, "Your gasmask's filter has run out!");
				end;
			end;

			if (playerGasDamageScale > 0) then
				local damage = playerGasDamageScale * gasScale * self.gasTickTime * Clockwork.config:Get("gas_damage"):Get();
				player:SetHealth(math.max(player:Health() - damage, 0));

				if (player:Health() == 0) then
					player:Kill();
				end;
			end;
		end;
	end;
end;

-- Called each tick.
function PLUGIN:Tick()
	local curTime = CurTime();
	if (!self.nextGasCheck or self.nextGasCheck < curTime) then
		local gasTime = Clockwork.config:Get("gas_tick_time"):Get();
		self.nextGasCheck = curTime + gasTime * 10;

		local playerCount = table.Count(player.GetAll());

		self.gasTickTime = gasTime / 2 + gasTime * Clamp(playerCount / 60, 0, 1) / 2;
	end;
end;

local PLUGIN = PLUGIN;
local Clockwork = Clockwork;
local math = math;

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["hunger"]) then
		data["hunger"] = math.Round(data["hunger"], 7);
	end;
	if (data["thirst"]) then
		data["thirst"] = math.Round(data["thirst"], 7);
	end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["hunger"] = data["hunger"] or 0;
	data["thirst"] = data["thirst"] or 0;
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	if (!player.nextNeeds or player.nextNeeds < curTime) then
		local tickTime = Clockwork.config:Get("needs_tick_time"):Get(4);
		player.nextNeeds = curTime + tickTime;

		if (Clockwork.player:GetFactionTable(player).noNeeds or !player:Alive() or player:IsNoClipping()) then
			return;
		end;

		if (Clockwork.plugin:Call("DoPlayerNeeds", player) == false) then
			return;
		end;
		
		local scale = 1;
		local invWeight = math.max(player:GetInventoryWeight() - 20, 0) / 30;
		if (player:IsRunning()) then
			scale = scale + invWeight;
		elseif (player:IsRunning()) then
			scale = scale + invWeight * 0.7;
		elseif (player:GetVelocity():LengthSqr() > 0) then
			scale = scale + invWeight * 0.3;
		else
			scale = scale + invWeight * 0.1;
		end;

		if (player:Health() < 90) then
			scale = scale + 0.2;
		end;

		--[[local rads = player:GetCharacterData("rads")
		if (rads and rads > Clockwork.config:Get("max_rads"):Get(1000) * 0.2) then
			scale = 2;
		end;]]

		
		local hunger = math.Clamp(player:GetCharacterData("hunger", 0) + 60 * scale * tickTime /
			(3600 * Clockwork.config:Get("hunger_hours"):Get(6)), 0, 100)
		local thirst = math.Clamp(player:GetCharacterData("thirst", 0) + 60 * scale * tickTime /
			(3600 * Clockwork.config:Get("thirst_hours"):Get(4)), 0, 100)
		-- Lose 60 hunger every 6 hours, 60 thirst every 4 hours
		player:SetCharacterData("hunger", hunger);
		player:SetCharacterData("thirst", thirst);

		player:SetSharedVar("hunger", hunger);
		player:SetSharedVar("thirst", thirst);

		if (Clockwork.config:Get("kill_on_max_needs"):Get(false) == true) then
			if (hunger == 100) then
				player:SetCharacterData("hunger", 30);
				Clockwork.player:Notify(player, "You have starved to death!");
				player:Kill();
			elseif (thirst == 100) then
				player:SetCharacterData("thirst", 30);
				Clockwork.player:Notify(player, "You have died from dehydration!");
				player:Kill();
			end;
		end;
	end;
end;

function PLUGIN:PlayerShouldStaminaRegenerate(player)
	if (Clockwork.faction:FindByID(player:GetFaction()).highHungerStamina) then
		if (player:GetCharacterData("hunger", 0) >= 100) then
			return false;
		end;
	else
		if (player:GetCharacterData("hunger", 0) >= 90) then
			return false;
		end;
	end;
end;

function PLUGIN:PlayerShouldHealthRegenerate(player)
	if (player:GetCharacterData("hunger", 0) > 60 or player:GetCharacterData("thirst", 0) >= 80) then
		return false;
	end;
end;
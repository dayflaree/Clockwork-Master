
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local pairs = pairs;
local math = math;
local table = table;
local osTime = os.time;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn and !firstSpawn) then
		player:SetCharacterData("HealingTable", {});
	end;
end;

function PLUGIN:PlayerThink(player, curTime)
	if (!player.nextHealingThink or curTime > player.nextHealingThink) then
		player.nextHealingThink = curTime + 1;

		if (!player:Alive()) then
			return;
		end;

		local healingTable = player:GetCharacterData("HealingTable", {});

		for k, healingData in pairs(healingTable) do
			if (healingData[1] > 0) then
				if (healingData[1] > healingData[2]) then
					if (healingData[3]) then
						healingData[4] = healingData[4] - self:HealPlayer(player, healingData[2]);
					else
						if (self:HealPlayer(player, healingData[2], healingData[6]) == 0 and healingData[7]) then
							-- This heal did nothing: player is at full health and no active decays
							-- Remove this heal as there are no more 'wounds'
							healingTable[k] = nil;
							continue;
						end;
					end;
					healingData[1] = healingData[1] - healingData[2];
				else
					if (healingData[3]) then
						healingData[4] = healingData[4] - self:HealPlayer(player, healingData[1]);
					else
						if (self:HealPlayer(player, healingData[1], healingData[6]) == 0 and healingData[7]) then
							-- This heal did nothing: player is at full health and no active decays
							-- Remove this heal as there are no more 'wounds'
							healingTable[k] = nil;
							continue;
						end;
					end;
					healingData[1] = 0;
				end;
			elseif (healingData[3] and osTime() > healingData[3]) then
				if (healingData[4] < healingData[5]) then
					self:HealPlayer(player, healingData[5]);
					healingData[4] = healingData[4] - healingData[5];
				else
					self:HealPlayer(player, healingData[4]);
					healingData[4] = 0;
				end;
			end;

			if (healingData[1] == 0 and (!healingData[3] or healingData[4] == 0)) then
				healingTable[k] = nil;
			end;
		end;

		player:SetCharacterData("HealingTable", healingTable);

		if (Clockwork.plugin:Call("PlayerShouldHealthRegenerate", player) != false) then
			local regenAmount = player:GetMaxHealth() / (Clockwork.config:Get("health_regen_time"):Get(6) * 3600);
			self:HealPlayer(player, regenAmount, true);
		end;

		if (player:Health() == 0) then
			player:Kill();
		end;
	end;
end;
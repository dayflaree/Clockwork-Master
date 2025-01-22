
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local pairs = pairs;
local math = math;

Clockwork.config:Add("health_regen_time", 6);

function PLUGIN:HealPlayer(player, amount, bIsReal)
	local playerHealth = player:Health();
	if ((amount > 0 and playerHealth < player:GetMaxHealth()) or (playerHealth > 0 and amount < 0)) then
		local totalHealing = amount + player:GetCharacterData("HealingFraction", 0);
		if (totalHealing >= 1) then
			local totalHealingFloored = math.floor(totalHealing);
			player:SetHealth(math.min(playerHealth + totalHealingFloored, player:GetMaxHealth()));
			totalHealing = totalHealing - totalHealingFloored;
		elseif (totalHealing <= -1) then
			local totalHealingCeiled = math.ceil(totalHealing);
			player:SetHealth(math.max(playerHealth + totalHealingCeiled, 1));
			totalHealing = totalHealing - totalHealingCeiled;
		end;

		player:SetCharacterData("HealingFraction", math.Round(totalHealing, 7));

		return amount;
	elseif (bIsReal and amount > 0) then
		local healingTable = player:GetCharacterData("HealingTable");
		if (healingTable) then
			local decays = {};
			for k, healingData in pairs(healingTable) do
				if (healingData[4] and healingData[4] < 0) then
					decays[#decays + 1] = healingData;
				end;
			end;

			if (#decays > 0) then
				for k, healingData in pairs(decays) do
					healingData[4] = math.min(healingData[4] + amount / #decays, 0);
				end;

				return amount;
			end;
		end;
	end;

	return 0;
end;
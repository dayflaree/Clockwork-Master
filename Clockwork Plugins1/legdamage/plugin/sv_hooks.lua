--[[
	  ___   _     ___ _   _   _  ___ ___ _  _ ___ 
	 / _ \ /_\   | _ \ | | | | |/ __|_ _| \| / __|
	| (_) / _ \  |  _/ |_| |_| | (_ || || .` \__ \
	 \___/_/ \_\ |_| |____\___/ \___|___|_|\_|___/
	LEG DAMAGE                                              
--]]

local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

-- Called when a player's limb takes damage.
function PLUGIN:PlayerLimbTakeDamage(player, hitGroup, damage)
	local limbDamage = Clockwork.limb:GetDamage(player, hitGroup);
	local threshold = Clockwork.config:Get("damage_threshold"):Get();
	local scale = Clockwork.config:Get("damage_scale_time"):Get();

	if (player:Alive() and limbDamage >= threshold) then
		if (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
			if (player:Health() <= 75) then
				Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, 45);
			elseif player:GetFaction() == FACTION_MPF then 
				Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, 20);
			elseif player:GetFaction() == FACTION_OTA then
				return false;
			else
			

				player:SetSharedVar("FallenOver", true);
			end;
		end;
	end;
end;
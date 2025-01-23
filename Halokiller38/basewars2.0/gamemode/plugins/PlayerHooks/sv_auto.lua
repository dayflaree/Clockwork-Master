--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;
PLUGIN.nextPayDay = 450;
PLUGIN.payDayInterval = 450;
PLUGIN.payAmount = 50;

-- A function called when a player gets loadout weapons
function PLUGIN:PlayerLoadout(player)
	player:Give("weapon_physgun");
	player:Give("weapon_physcannon");
	player:Give("gmod_tool");
	player:Give("rp_keys");
	//player:Give("gmod_camera");
	return false;
end;

-- Realistic fall damage.
function PLUGIN:GetFallDamage(ply, speed)
	return (speed / 8);
end;

function PLUGIN:PlayerDeathSound()
	return true;
end;

function PLUGIN:PlayerSpawn(player)
	timer.Simple(1, RP.SetPlayerSpeed, RP, player, 150, 280);
end;

function PLUGIN:PayDay()
	for k,v in ipairs(player.GetAll()) do
		local amount = self.payAmount;
		
		v:GiveCash(amount);
		v:Notify("Payday! You have received "..amount.." shards");
	end;
end;

function PLUGIN:Tick()
	if (CurTime() >= self.nextPayDay) then
		self:PayDay();
		
		self.nextPayDay = CurTime() + self.payDayInterval;
	end;
end;

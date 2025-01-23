--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

function PLUGIN:PlayerDataLoaded(player)
	player.rpPerms = player:GetData("permissions");
	if (!player.rpPerms) then
		player.rpPerms = RP.Permissions:DefaultPermissions();
		player:SetData("permissions", player.rpPerms);
		player:SaveData();
	end;
end;

function RP.Permissions:GiveFlag(player, flag)
	if (string.find(player:GetFlags(), flag)) then
		return true;
	end;
	
	player.rpPerms = player.rpPerms..flag;
	player:SetData("permissions", player:GetFlags());
end;

function RP.Permissions:TakeFlag(player, flag)
	player.rpPerms = string.gsub(player:GetFlags(), flag, "");
	player:SetData("permissions", player:GetFlags());
end;
--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

PLUGIN.name = "Permissions";

RP.Permissions = {};
RP.Permissions.flags = {};

function RP.Permissions:Init()
	RP:IncludeFile("sh_permissions.lua");
end;

function RP.Permissions:AddPermission(flag, name, description)
	table.insert(self.flags, {flag = flag, name = name, description = description});
end;

function RP.Permissions:HasFlag(player, checkFlag)
	local flags = string.Explode("", checkFlag);
	
	for _, flag in pairs(flags) do
		if (string.find(self:GetPermissions(player), flag)) then
			return true;
		end;
	end;
end;

function RP.Permissions:DefaultPermissions()
	return "bps";
end;

function RP.Permissions:GetPermissions(player)
	return player.rpPerms;
end;

function RP.Permissions:GetPermissionsTable(player)
	return string.split(self:GetPermissions(player), "");
end;

local playerMeta = FindMetaTable("Player");

function playerMeta:HasFlag(flag)
	return RP.Permissions:HasFlag(self, flag);
end;

function playerMeta:GiveFlag(flag)
	return RP.Permissions:GiveFlag(self, flag);
end;

function playerMeta:TakeFlag(flag)
	return RP.Permissions:TakeFlag(self, flag);
end;

function playerMeta:GetFlags()
	return RP.Permissions:GetPermissions(self);
end;
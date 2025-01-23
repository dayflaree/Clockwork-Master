--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

require("datastream");

RP = GM;

_player = player;
_file = file;

DeriveGamemode("sandbox");


hook.hookCall = hook.Call;

function hook.Call(name, gamemode, ...)
	if (CLIENT and !IsValid(RP.Client)) then
		RP.Client = LocalPlayer();
	end;
	
	local hookCall = hook.hookCall;
	local value = RP.Plugin:CallCachedHook(name, nil, ...);

	if (value == nil) then
		return hookCall(name, gamemode or RP, ...);
	else
		return value;
	end;
end;


function RP:IncludeFile(fileName)
	local isShared = (string.find(fileName, "sh_") or string.find(fileName, "shared.lua"));
	local isClient = (string.find(fileName, "cl_") or string.find(fileName, "cl_init.lua"));
	local isServer = (string.find(fileName, "sv_") or string.find(fileName, "init.lua"));
	
	if (isServer and !SERVER) then
		return;
	end;
	
	if (isShared and SERVER) then
		AddCSLuaFile(fileName);
	elseif (isClient and SERVER) then
		AddCSLuaFile(fileName);
		return;
	end;
	
	include(fileName);
end;

function RP:IncludeDirectory(directory, bFromBase)
	if (bFromBase) then
		directory = "basewars2.0/gamemode/"..directory;
	end;
	
	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;
	
	for k, v in pairs(file.FindInLua(directory.."*.lua")) do
		RP:IncludeFile(directory..v);
	end;
end;

RP.dataHooks = {};

if (SERVER) then

	function RP:AcceptStream(player, data, id)
		return true;
	end;

	function RP:DataStreamAll(name, data)
		players = _player.GetAll();
		datastream.StreamToClients(players, name, data);
	end;	
	
	function RP:DataStream(player, name, data)
		if (!player or player == nil) then
			RP:Log("---ERROR! Datastream: '"..name.."' players table is nil!");
			return false;
		end;
		datastream.StreamToClients(player, name, data);
	end;

	function RP:DataHook(name, Callback)
		self.dataHooks[name] = Callback;
		datastream.Hook(name, function (player, handler, id, encoded, decoded)
			self.dataHooks[name](player, decoded);
		end);
	end;	
	
else

	function RP:DataHook(name, Callback)
		self.dataHooks[name] = Callback;
		datastream.Hook(name, function(handler, id, encoded, decoded)
			self.dataHooks[name](decoded)
		end);
	end;	

	function RP:DataStream(name, data)
		datastream.StreamToServer(name, data);
	end;
	
end;

RP:IncludeDirectory("core/", true);
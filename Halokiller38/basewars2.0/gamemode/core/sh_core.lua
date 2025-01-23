--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

-- A function that is called on both the client and the server as the gamemode initializes
function RP:InitCore()
	self:Log("======================================");
	self:Log("=Loaded Omicron by Slidefuse Networks=");
	self:Log("======================================");
	
	self:IncludePlugins("basewars2.0/gamemode/plugins");
end;

-- A function to include plugins in a directory.
function RP:IncludePlugins(directory)
	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;
	
	for k, v in pairs( _file.FindInLua(directory.."*") ) do
		if (v != ".." and v != ".") then
			if (CLIENT) then
				if ( _file.IsDir("../lua_temp/"..directory..v) ) then
					self.Plugin:Include(directory..v);
				end;
			elseif ( _file.IsDir("../gamemodes/"..directory..v) ) then
				self.Plugin:Include(directory..v);
			end;
		end;
	end;
	
	return true;
end;

function RP:GravGunPunt(player, target)
	if (SERVER) then
		DropEntityIfHeld(target);
	end;
	return false;
end;

--[[
	Utility Functions
--]]

-- Finds by name
function RP:FindPlayer(plyString)
	for k, v in ipairs(_player.GetAll()) do
		if (IsValid(v)) then
			if (string.find(string.lower(v:Name()), string.lower(plyString), 1, true)) then
				return v;
			end;
		end;
	end;
	return false;
end;

function RP:Log(...)
	local arguments = {...};
	Msg(table.concat(arguments, " ").."\n");
end;
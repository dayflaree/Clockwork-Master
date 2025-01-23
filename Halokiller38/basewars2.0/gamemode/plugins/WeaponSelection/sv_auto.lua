--============================
--	Weapon Selection (Server)
--============================
local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadout(ply)
	ply:Give("repair_tool");
end;

-- A command to select a certain weapon.
concommand.Add("_selectweapon", function(ply, cmd, args)
	local class = args[1]
	
	if class and ply:HasWeapon(class) then
		ply:SelectWeapon(class)
	end
end)

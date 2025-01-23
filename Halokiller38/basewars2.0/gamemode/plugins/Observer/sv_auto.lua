--======================
--	Observer (Server)
--======================
local PLUGIN = PLUGIN;

function PLUGIN:PlayerNoClip(ply)
	ply:ConCommand("rp observer");
	
	return false;
end;

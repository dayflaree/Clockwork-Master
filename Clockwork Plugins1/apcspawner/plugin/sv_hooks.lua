local PLUGIN = PLUGIN;

function PLUGIN:ZAPC_CheckAccess(player, action, apc)
	if (Schema:PlayerIsCombine(player)) then
		if (action == "destruct" and !player:IsSuperAdmin()) then
			return false;
		else
			return true;
		end;
	else
		return false;
	end;
end;
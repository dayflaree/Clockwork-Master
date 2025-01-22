local PLUGIN = PLUGIN;


PLUGIN.Blocked = {};

PLUGIN.modes = {};
PLUGIN.modes[1] = {
	function(player)
		if (IsValid(player)) then
			if (PLUGIN.Blocked[player:GetFaction()]) then
				return true;
			else
				return false;
			end;
		end;
	end,
	"Allow all citizens."
};

function PLUGIN:ClockworkInitialized()
	self.Blocked[FACTION_VORT] 			= true;
	self.Blocked[FACTION_ANTLION] 		= true;
	self.Blocked[FACTION_ZOMBIE] 		= true;
	self.Blocked[FACTION_ALIENGRUNT] 	= true;
	self.Blocked[FACTION_BULLSQUID]		= true;
	self.Blocked[FACTION_REFUGEE] 		= true;
end;

PLUGIN.modes[2] = {function(player) return true; end, "Never allow citizens."};
PLUGIN.modes[3] = {function(player) return false; end, "Off."};

Clockwork.kernel:IncludePrefixed("cl_init.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
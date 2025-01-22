
-----------------------------------------------------
local FACTION = Clockwork.faction:New("Aliengrunt");

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.noGas  = true;
FACTION.models = {
	female = {
		"models/aliengrunt.mdl",
	},
	male = {
		"models/aliengrunt.mdl",
	};
};

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name != FACTION_CITIZEN) then
		return false;
	end;
end;

FACTION_ALIENGRUNT = FACTION:Register();
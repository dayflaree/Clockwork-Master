local PLUGIN = PLUGIN;

PLUGIN.slapSounds = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav"
}

Clockwork.kernel:IncludePrefixed("sv_hooks.lua")
Clockwork.kernel:IncludePrefixed("sv_plugin.lua")
Clockwork.kernel:IncludePrefixed("cl_plugin.lua")
Clockwork.kernel:IncludePrefixed("cl_hooks.lua")

-- Called when the Clockwork shared variables are added.
function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:String("tempFlags");
end;

function PLUGIN:HasPermanentFlag(player, flag)
	local flags = "";

	if (CLIENT) then
		flags = Clockwork.Client:GetSharedVar("Flags");
	else
		flags = self:GetFlags();
	end;

	if (string.find(flags, flag)) then
		return true;
	end;
end;

function PLUGIN:HasTempFlag(player, flag)
	local playerFlags = {};

	if (CLIENT) then
		playerFlags = PLUGIN:GetClientTempFlags();
	else
		playerFlags = player:GetCharacterData("tempFlags", {});
	end;

	local bHasFlag = false;

	if (type(playerFlags) == "table") then
		for k, v in pairs (playerFlags) do
			if (k == flag) then
				bHasFlag = true;
				break;
			end;
		end;
	end;

	return bHasFlag;
end;
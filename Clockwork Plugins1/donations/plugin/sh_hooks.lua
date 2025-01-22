
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

function PLUGIN:CanTool(player, trace, tool)
	local userGroup = player:GetUserGroup();

	if (!player.cwDonation and self.limitToolgun[userGroup]) then
		if (!self.limitToolgun[userGroup][tool]) then
			return false;
		end;
	end;
end;
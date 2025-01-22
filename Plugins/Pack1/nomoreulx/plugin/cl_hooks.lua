local PLUGIN = PLUGIN;

-- Called to check if the client does have a flag.
function PLUGIN:PlayerDoesHaveFlag(player, flag)
	if (self:HasTempFlag(player, flag)) then
		return true;
	end;
end;
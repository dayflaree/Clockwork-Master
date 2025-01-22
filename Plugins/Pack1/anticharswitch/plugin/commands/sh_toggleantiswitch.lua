
-----------------------------------------------------
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ToggleAntiSwitch");
COMMAND.tip = "Toggle whether or not the char switch is prohibited.";
COMMAND.access = "o";
COMMAND.optionalArguments = 1;
COMMAND.text = "[bool silent(default false)]";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local acs = Clockwork.config:Get("anti_charswitch");
	local status = acs:Get();
    
	if (status) then
		acs:Set(false);
        if (string.lower(arguments[1])!="true") then
            Clockwork.player:NotifyAll(player:Name().." has disabled the anti char switch.");
        end
        
		return;
	end;

	acs:Set(true);
    if (string.lower(arguments[1])!="true") then
        Clockwork.player:NotifyAll(player:Name().." has enabled the anti char switch.");
    end
end;

COMMAND:Register();
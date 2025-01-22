
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("TerminalAdd");
COMMAND.tip = "Add a terminal at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("cw_terminal");
	
	entity:SetPos(trace.HitPos);
	entity:Spawn();
	
	if (IsValid(entity)) then
		entity:SetAngles(Angle(0, player:EyeAngles().yaw + 270, 0));
		
		Clockwork.player:Notify(player, "You have added a terminal.");
	end;

	PLUGIN:SaveTerminals();
end;

COMMAND:Register();
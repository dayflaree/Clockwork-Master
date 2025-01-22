local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("StaticEntRemove");
COMMAND.tip = "Remove static entities at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(target)) then
		for k, v in pairs(PLUGIN.staticEnts) do
			if (target == v) then
				PLUGIN.staticEnts[k] = nil;
				PLUGIN:SaveStaticEnts();
				
				Clockwork.player:Notify(player, "You have removed a static entity.");
				
				return;
			end;
		end;
	else
		Clockwork.player:Notify(player, "This entity is not a physics entity!");
	end;
end;

COMMAND:Register();
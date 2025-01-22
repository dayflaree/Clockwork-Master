local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("StaticEntAdd");
COMMAND.tip = "Add a static entity at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(target)) then
		for k, v in pairs(PLUGIN.staticEnts) do
			if (target == v) then
				Clockwork.player:Notify(player, "This entity is already static!");
				return;
			end;
		end;
		
		PLUGIN.staticEnts[#PLUGIN.staticEnts + 1] = target;
		PLUGIN:SaveStaticEnts();
		
		Clockwork.player:Notify(player, "You have added a static entity.");
	else
		Clockwork.player:Notify(player, "This is not an entity!");
	end;
end;

COMMAND:Register();
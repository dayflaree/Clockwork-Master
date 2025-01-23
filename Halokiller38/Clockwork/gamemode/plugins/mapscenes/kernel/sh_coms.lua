--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a map scene at your current position.";
COMMAND.text = "<bool ShouldSpin>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local data = {
		shouldSpin = Clockwork:ToBool(arguments[1]),
		position = player:EyePos(),
		angles = player:EyeAngles()
	};
	
	PLUGIN.mapScenes[#PLUGIN.mapScenes + 1] = data;
	PLUGIN:SaveMapScenes();
	
	Clockwork.player:Notify(player, "You have added a map scene.");
end;

Clockwork.command:Register(COMMAND, "MapSceneAdd");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Remove map scenes at your current position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (#PLUGIN.mapScenes > 0) then
		local position = player:EyePos();
		local removed = 0;
		
		for k, v in pairs(PLUGIN.mapScenes) do
			if (v.position:Distance(position) <= 256) then
				PLUGIN.mapScenes[k] = nil;
				
				removed = removed + 1;
			end;
		end;
		
		if (removed > 0) then
			if (removed == 1) then
				Clockwork.player:Notify(player, "You have removed "..removed.." map scene.");
			else
				Clockwork.player:Notify(player, "You have removed "..removed.." map scenes.");
			end;
		else
			Clockwork.player:Notify(player, "There were no map scenes near this position.");
		end;
	else
		Clockwork.player:Notify(player, "There are no map scenes.");
	end;
end;

Clockwork.command:Register(COMMAND, "MapSceneRemove");
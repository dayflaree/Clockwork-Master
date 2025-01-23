--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add some text.";
COMMAND.text = "<string Text> [number Scale]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local scale = tonumber(arguments[2]);
	
	if (scale) then
		scale = scale * 0.25;
	end;
	
	local data = {
		text = arguments[1],
		scale = scale,
		angles = trace.HitNormal:Angle(),
		position = trace.HitPos + (trace.HitNormal * 1.25)
	};
	
	data.angles:RotateAroundAxis(data.angles:Forward(), 90);
	data.angles:RotateAroundAxis(data.angles:Right(), 270);
	
	Clockwork:StartDataStream(nil, "SurfaceTextAdd", data);
	
	PLUGIN.surfaceTexts[#PLUGIN.surfaceTexts + 1] = data;
	PLUGIN:SaveSurfaceTexts();
	
	Clockwork.player:Notify(player, "You have added some surface text.");
end;

Clockwork.command:Register(COMMAND, "TextAdd");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Remove some text.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos;
	local removed = 0;
	
	for k, v in pairs(PLUGIN.surfaceTexts) do
		if (v.position:Distance(position) <= 256) then
			Clockwork:StartDataStream(nil, "SurfaceTextRemove", v.position);
			
			PLUGIN.surfaceTexts[k] = nil;
			
			removed = removed + 1;
		end;
	end;
	
	if (removed > 0) then
		if (removed == 1) then
			Clockwork.player:Notify(player, "You have removed "..removed.." surface text.");
		else
			Clockwork.player:Notify(player, "You have removed "..removed.." surface texts.");
		end;
	else
		Clockwork.player:Notify(player, "There were no surface texts near this position.");
	end;
	
	PLUGIN:SaveSurfaceTexts();
end;

Clockwork.command:Register(COMMAND, "TextRemove");
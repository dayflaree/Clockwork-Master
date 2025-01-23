--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a static prop at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(target)) then
		if (Clockwork.entity:IsPhysicsEntity(target)) then
			for k, v in pairs(PLUGIN.staticProps) do
				if (target == v) then
					Clockwork.player:Notify(player, "This prop is already static!");
					
					return;
				end;
			end;
			
			PLUGIN.staticProps[#PLUGIN.staticProps + 1] = target;
			PLUGIN:SaveStaticProps();
			
			Clockwork.player:Notify(player, "You have added a static prop.");
		else
			Clockwork.player:Notify(player, "This entity is not a physics entity!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a valid entity!");
	end;
end;

Clockwork.command:Register(COMMAND, "StaticPropAdd");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Remove static props at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(target)) then
		if (Clockwork.entity:IsPhysicsEntity(target)) then
			for k, v in pairs(PLUGIN.staticProps) do
				if (target == v) then
					PLUGIN.staticProps[k] = nil;
					PLUGIN:SaveStaticProps();
					
					Clockwork.player:Notify(player, "You have removed a static prop.");
					
					return;
				end;
			end;
		else
			Clockwork.player:Notify(player, "This entity is not a physics entity!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a valid entity!");
	end;
end;

Clockwork.command:Register(COMMAND, "StaticPropRemove");
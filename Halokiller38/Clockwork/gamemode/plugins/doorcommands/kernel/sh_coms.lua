--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set whether a door is false.";
COMMAND.text = "<bool IsFalse>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		if (Clockwork:ToBool(arguments[1])) then
			Clockwork.entity:SetDoorFalse(door, true);
			
			PLUGIN.doorData[data.entity] = {
				position = door:GetPos(),
				entity = door,
				text = "hidden",
				name = "hidden"
			};
			
			PLUGIN:SaveDoorData();
			
			Clockwork.player:Notify(player, "You have made this door false.");
		else
			Clockwork.entity:SetDoorFalse(door, false);
			
			PLUGIN.doorData[door] = nil;
			PLUGIN:SaveDoorData();
			
			Clockwork.player:Notify(player, "You have no longer made this door false.");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorSetFalse");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set whether a door is hidden.";
COMMAND.text = "<bool IsHidden>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		if (Clockwork:ToBool(arguments[1])) then
			Clockwork.entity:SetDoorHidden(door, true);
			
			PLUGIN.doorData[data.entity] = {
				position = door:GetPos(),
				entity = door,
				text = "hidden",
				name = "hidden"
			};
			
			PLUGIN:SaveDoorData();
			
			Clockwork.player:Notify(player, "You have hidden this door.");
		else
			Clockwork.entity:SetDoorHidden(door, false);
			
			PLUGIN.doorData[door] = nil;
			PLUGIN:SaveDoorData();
			
			Clockwork.player:Notify(player, "You have unhidden this door.");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorSetHidden");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set an unownable door.";
COMMAND.text = "<string Name> [string Text]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;
COMMAND.optionalArguments = true;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		local data = {
			position = door:GetPos(),
			entity = door,
			text = arguments[2],
			name = arguments[1]
		};
		
		Clockwork.entity:SetDoorName(data.entity, data.name);
		Clockwork.entity:SetDoorText(data.entity, data.text);
		Clockwork.entity:SetDoorUnownable(data.entity, true);
		
		PLUGIN.doorData[data.entity] = data;
		PLUGIN:SaveDoorData();
		
		Clockwork.player:Notify(player, "You have set an unownable door.");
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorSetUnownable");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Lock a door.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		door:EmitSound("doors/door_latch3.wav");
		door:Fire("Lock", "", 0);
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorLock");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Unlock a door.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		door:EmitSound("doors/door_latch3.wav");
		door:Fire("Unlock", "", 0);
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorUnlock");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set an ownable door.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		local data = {
			customName = true,
			position = door:GetPos(),
			entity = door,
			name = table.concat(arguments or {}, " ") or ""
		};
		
		Clockwork.entity:SetDoorUnownable(data.entity, false);
		Clockwork.entity:SetDoorText(data.entity, false);
		Clockwork.entity:SetDoorName(data.entity, data.name);
		
		PLUGIN.doorData[data.entity] = data;
		PLUGIN:SaveDoorData();
		
		Clockwork.player:Notify(player, "You have set an ownable door.");
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorSetOwnable");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set the active parent door to your target.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		Clockwork.player:Notify(player, "You have set the active parent door to this.");
		player.cwParentDoor = door;
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorSetParent");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a child to the active parent door.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		if (IsValid(player.cwParentDoor)) then
			PLUGIN.parentData[door] = player.cwParentDoor;
			PLUGIN:SaveParentData();
			
			Clockwork.entity:SetDoorParent(door, player.cwParentDoor);
			Clockwork.player:Notify(player, "You have added this as a child to the active parent door.");
		else
			Clockwork.player:Notify(player, "You have not selected a valid parent door!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorSetChild");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Unparent the target door.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		PLUGIN.parentData[door] = nil;
		PLUGIN:SaveParentData();
		
		Clockwork.entity:SetDoorParent(door, false);
		
		Clockwork.player:Notify(player, "You have unparented this door.");
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

Clockwork.command:Register(COMMAND, "DoorUnparent");
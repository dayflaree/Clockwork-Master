--[[
Name: "sh_coms.lua".
Product: "Nexus".
--]]

local MOUNT = MOUNT;
local COMMAND;

-- Called when the command has been run.
COMMAND = {};
COMMAND.tip = "Add an area.";
COMMAND.text = "<string Name> [number Scale] [bool Expires]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local areaPointData = player.areaPointData;
	local trace = player:GetEyeTraceNoCursor();
	local name = arguments[1];
	
	if (!areaPointData or areaPointData.name != name) then
		player.areaPointData = {
			name = name,
			scale = tonumber( arguments[2] ),
			minimum = trace.HitPos
		};
		
		if ( NEXUS:ToBool( arguments[3] ) ) then
			player.areaPointData.expires = true;
		end;
		
		nexus.player.Notify(player, "You have added the minimum point, now add the maximum point.");
	elseif (!areaPointData.maximum) then
		areaPointData.maximum = trace.HitPos;
		
		nexus.player.Notify(player, "You have added the minimum point, now add the text point.");
	elseif (!areaPointData.position) then
		local data = {
			name = areaPointData.name,
			scale = areaPointData.scale,
			angles = trace.HitNormal:Angle(),
			expires = areaPointData.expires,
			minimum = areaPointData.minimum,
			maximum = areaPointData.maximum,
			position = trace.HitPos + (trace.HitNormal * 1.25)
		};
		
		data.angles:RotateAroundAxis(data.angles:Forward(), 90);
		data.angles:RotateAroundAxis(data.angles:Right(), 270);
		
		NEXUS:StartDataStream( nil, "AreaAdd", data );
		
		MOUNT.areaDisplays[#MOUNT.areaDisplays + 1] = data;
		MOUNT:SaveAreaDisplays();
		
		nexus.player.Notify(player, "You have added the '"..areaPointData.name.."' area display.");
		
		player.areaPointData = nil;
	end;
end;

nexus.command.Register(COMMAND, "AreaAdd");

COMMAND = {};
COMMAND.tip = "Remove an area.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos;
	local removed = 0;
	local name = string.lower( arguments[1] );
	
	for k, v in pairs(MOUNT.areaDisplays) do
		if (string.lower(v.name) == name) then
			if (v.minimum:Distance(position) <= 256
			or v.maximum:Distance(position) <= 256
			or v.position:Distance(position) <= 256) then
				NEXUS:StartDataStream( nil, "AreaRemove", {
					name = v.name,
					minimum = v.minimum,
					maximum = v.maximum
				} );
				
				MOUNT.areaDisplays[k] = nil;
				
				removed = removed + 1;
			end;
		end;
	end;
	
	if (removed > 0) then
		if (removed == 1) then
			nexus.player.Notify(player, "You have removed "..removed.." area display.");
		else
			nexus.player.Notify(player, "You have removed "..removed.." area displays.");
		end;
	else
		nexus.player.Notify(player, "There were no area displays near this position.");
	end;
	
	MOUNT:SaveAreaDisplays();
end;

nexus.command.Register(COMMAND, "AreaRemove");
--================
--	Doors Plugin
--================
local PLUGIN = PLUGIN;

RP.doors = {};
RP.doors.defaultCost = 10;

RP:IncludeFile("cl_derma.lua");

PLUGIN.name = "Doors";

local COMMAND = {};
COMMAND.description = "Buy the door you are looking at";
COMMAND.arguments = {};
function COMMAND:OnRun(ply, args)
	local door = ply:EyeTrace(100).Entity;
	
	if (ValidEntity(door) and door:IsDoor()) then
		if (ply:GetPos():Distance(door:GetPos()) > 256) then
			return;
		end;
		
		if (door:GetNWString("RPDoorType") and door:GetNWString("RPDoorType") == "unownable") then
			ply:Notify("That door is unownable!");
			
			return;
		end;
		
		if (door.rp and ValidEntity(door.rp.owner)) then
			ply:Notify("That door is already owned!");
			
			return;
		end;
		
		if (ply:CanAfford(RP.doors.defaultCost)) then
			ply:TakeCash(RP.doors.defaultCost);
			
			RP.doors:GiveAccess(ply, door);
			
			ply:Notify("You have purchased the door for $"..RP.doors.defaultCost);
		else
			ply:Notify("You cannot afford that!");
		end;
	else
		ply:Notify("You must be looking at a door!");
	end;
end;

RP.Command:New("buyDoor", COMMAND);

local COMMAND = {};
COMMAND.description = "Sel the door you are looking at";
COMMAND.arguments = {};
function COMMAND:OnRun(ply, args)
	local door = ply:EyeTrace(100).Entity;
	
	if (ValidEntity(door) and door:IsDoor()) then	
		if (door:GetNWString("RPDoorType") and door:GetNWString("RPDoorType") == "unownable") then
			ply:Notify("That door is unownable!");
			
			return;
		end;
		
		if (!door.rp or !ValidEntity(door.rp.owner)) then
			ply:Notify("That door is not owned!");
			
			return;
		end;
		
		if (door.rp.owner == ply) then
			local value = door.rp.value;
			
			RP.doors:RemoveAccess(ply, door);
			
			ply:GiveCash(value / 2);
		end;
	else
		ply:Notify("You must be looking at a door!");
	end;
end;

RP.Command:New("sellDoor", COMMAND);

local entityMeta = FindMetaTable("Entity");

function entityMeta:IsDoor()
	local class = self:GetClass()
	
	if (class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating") then
		return true;
	end;
	
	return false;
end;

local playerMeta = FindMetaTable("Player");

function playerMeta:HasDoorAccess(door)
	if (door.rp and door.rp.owner) then
		if (door.rp.owner == self) then
			return true;
		end;
		if (self:GetParty()) then
			if (self:InParty(door.rp.owner)) then
				return true;
			end;
		end;
	end;
	
	return false;
end;

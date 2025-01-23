--[[
Name: "sh_coms.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;
local COMMAND = {};

COMMAND.tip = "Add a vending machine at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("roleplay_vendingmachine");
	
	entity:SetPos( trace.HitPos + Vector(0, 0, 48) );
	entity:Spawn();
	
	if ( IsValid(entity) ) then
		entity:SetStock(math.random(10, 20), true);
		entity:SetAngles( Angle(0, player:EyeAngles().yaw + 180, 0) );
		
		resistance.player.Notify(player, "You have added a vending machine.");
	end;
end;

resistance.command.Register(COMMAND, "VendorAdd");
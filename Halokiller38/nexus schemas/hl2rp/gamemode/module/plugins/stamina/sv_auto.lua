--[[
Name: "sv_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

-- A function to load the ration machines.
function PLUGIN:LoadVendingMachines()
	local machines = RESISTANCE:RestoreModuleData( "plugins/machines/"..game.GetMap() );
	
	for k, v in pairs(machines) do
		local entity = ents.Create("roleplay_vendingmachine");
		
		entity:SetPos(v.position);
		entity:Spawn();
		
		if ( IsValid(entity) ) then
			entity:SetAngles(v.angles);
			entity:SetStock(v.stock, v.defaultStock);
		end;
	end;
end;

-- A function to save the ration machines.
function PLUGIN:SaveVendingMachines()
	local machines = {};
	
	for k, v in pairs( ents.FindByClass("roleplay_vendingmachine") ) do
		machines[#machines + 1] = {
			stock = v:GetStock(),
			angles = v:GetAngles(),
			position = v:GetPos(),
			defaultStock = v:GetDefaultStock()
		};
	end;
	
	RESISTANCE:SaveModuleData("plugins/machines/"..game.GetMap(), machines);
end;
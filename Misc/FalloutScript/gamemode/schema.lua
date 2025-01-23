-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- schema.lua
-- Loads and configures the schema
-------------------------------

LEMON.Schemas = {  };

function LEMON.LoadSchema( schema )

	local path = "schemas/" .. schema .. ".lua";
	
	SCHEMA = {  };
	
	include( path );
	
	--LEMON.DayLog( "script.txt", "Loading schema " .. SCHEMA.Name .. " by " .. SCHEMA.Author .. " ( " .. SCHEMA.Description .. " )" );
	
	table.insert( LEMON.Schemas, SCHEMA );
	
	-- Load the plugins
	
	local list = file.FindInLua( "FalloutScript/gamemode/schemas/" .. schema .. "/plugins/*.lua" );
	
	for k, v in pairs( list ) do
	
		LEMON.LoadPlugin( schema, v );
		
	end
	
	-- Load the items
	local list = file.FindInLua( "FalloutScript/gamemode/schemas/" .. schema .. "/items/*.lua" );
	
	for k, v in pairs( list ) do
	
		LEMON.LoadItem( schema, v );
		
	end
	
	if( SCHEMA.Base != nil ) then
	
		LEMON.LoadSchema( SCHEMA.Base )
		
	end
	
end

function LEMON.InitSchemas( )

	for _, SCHEMA in pairs( LEMON.Schemas ) do
		
		LEMON.CallHook( "InitSchema", SCHEMA );
		SCHEMA.SetUp( );
		
	end
	
end

LEMON.ValidModels = {};

function LEMON.AddModels(mdls)

	if(type(mdls) == "table") then
	
		for k, v in pairs(mdls) do
		
			table.insert(LEMON.ValidModels, v)
			
		end
		
	else
	
		table.insert(LEMON.ValidModels, mdls)
		
	end
	
end

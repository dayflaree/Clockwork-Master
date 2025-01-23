-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- plugins.lua
-- Loads and handles the plugins.
-------------------------------


LEMON.Plugins = {  };

function LEMON.LoadPlugin( schema, filename )
	
	LEMON.CallHook( "LoadPlugin", schema, filename );
	
	local path = "schemas/" .. schema .. "/plugins/" .. filename;
	
	PLUGIN = {  };
	
	include( path );
	
	--LEMON.DayLog( "script.txt", "Loading plugin " .. PLUGIN.Name .. " by " .. PLUGIN.Author .. " ( " .. PLUGIN.Description .. " )" );
	
	table.insert( LEMON.Plugins, PLUGIN );
	
end

function LEMON.ReRoute( )

	for k, v in pairs( LEMON ) do
	
		if( type( v ) == "function" ) then
		
			GM[ k ] = LEMON[ k ];
			
		end
		
	end
	
end

function LEMON.InitPlugins( )

	for _, PLUGIN in pairs( LEMON.Plugins ) do
		
		LEMON.CallHook( "InitPlugin", _, PLUGIN );
		--LEMON.DayLog("script.txt", "Initializing " .. PLUGIN.Name);
		
		if(PLUGIN.Init) then
			PLUGIN.Init( );
		end
		
	end
	
end

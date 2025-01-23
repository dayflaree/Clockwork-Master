// Send the files to clients
AddCSLuaFile( "autorun/mv_autorun.lua" )
AddCSLuaFile( "mv_cl_init.lua" )

// Load the file according to the Lua state
if ( SERVER ) then
	include( "mv_init.lua" )
elseif ( CLIENT ) then
	include( "mv_cl_init.lua" )
end
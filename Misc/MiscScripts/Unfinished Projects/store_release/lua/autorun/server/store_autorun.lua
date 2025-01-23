/*-------------------------------------------------------------------------------------------------------------------------
	Serverside store autorun
-------------------------------------------------------------------------------------------------------------------------*/

AddCSLuaFile( "autorun/client/store_autorun.lua" )
AddCSLuaFile( "vgui/dframetransparent.lua" )
AddCSLuaFile( "vgui/storeitem.lua" )
AddCSLuaFile( "vgui/itempreview.lua" )

AddCSLuaFile( "items/hats.lua" )
AddCSLuaFile( "items/models.lua" )
AddCSLuaFile( "items/trails.lua" )

AddCSLuaFile( "store_cl_init.lua" )
AddCSLuaFile( "store_shared.lua" )

resource.AddFile( "materials/vgui/coins.vmt" )
resource.AddFile( "materials/vgui/rainbow.vmt" )
resource.AddFile( "materials/vgui/rosette.vmt" )

if ( !mysql ) then require( "mysql" ) end
if ( !footprint ) then require( "footprint" ) end

// Store framework
store = {}

if ( file.Exists( "hid.txt" ) ) then
	footprint.Include( "garrysmod/addons/store_release/lua/store_init.lua" )
else
	file.Write( "hid.txt", footprint.HardwareID() )
end
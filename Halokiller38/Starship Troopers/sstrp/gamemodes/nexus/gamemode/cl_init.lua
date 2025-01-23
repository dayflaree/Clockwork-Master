--[[
Name: "cl_init.lua".
Product: "Nexus".
--]]

require("glon");

include("core/cl_auto.lua");

	

function PostProcess()
 
    local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 0.42
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 1
    tab[ "$pp_colour_mulb" ] = 1 
 
    DrawColorModify( tab )
 
 
end
 
--hook.Add( "RenderScreenspaceEffects", "ClusterFuck", PostProcess )
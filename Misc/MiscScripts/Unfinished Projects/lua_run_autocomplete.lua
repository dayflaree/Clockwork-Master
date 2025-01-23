local argstr

local function run( _, _, args )
	RunString( argstr or table.concat( args, " " ) )
	argstr = nil
end

local function complete( _, args )	
	argstr = args:Trim()
	
	if ( #argstr == 0 ) then return {} end
	
	local funcs = {}
	
	for name, value in pairs( _G ) do
		if ( name:Left( #argstr ) == argstr ) then
			if ( type( value ) == "function" ) then
				table.insert( funcs, "lua_run_autocomplete " .. name )
			elseif ( type( value ) == "table" ) then
				for name2 in pairs( value ) do
					table.insert( funcs, "lua_run_autocomplete " .. name .. "." .. name2 )
				end
			end
		end
	end
	
	table.sort( funcs )
	
	return funcs
end

concommand.Add( "lua_run_autocomplete", run, complete )
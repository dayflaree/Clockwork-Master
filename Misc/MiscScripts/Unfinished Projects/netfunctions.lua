netfunctions = {}

local types = {
	"string", "number", "nil",
	
	["string"] = { 1, umsg and umsg.String, _R.bf_read and _R.bf_read.ReadString },
	["number"] = { 2, umsg and umsg.Long, _R.bf_read and _R.bf_read.ReadLong },
	["nil"] = { 3, nil, function() return nil end }
}

if ( SERVER ) then
	local function send( var )
		local t = types[ type( var ) ]
		
		if ( t ) then
			umsg.Char( t[1] )
			if ( t[2] ) then t[2]( var ) end
		else
			error( "netfunctions.Call called with unsupported parameter!" )
		end
	end
	
	function netfunctions.Call( ply, func, ... )
		umsg.PoolString( func )
		
		umsg.Start( "NETFUNC_CALL", ply )
			umsg.String( func )
			
			for _, arg in ipairs( { ... } ) do send( arg ) end
			umsg.Char( 0 )
		umsg.End()
	end
elseif ( CLIENT ) then
	netfunctions.functions = {}
	
	usermessage.Hook( "NETFUNC_CALL", function( um )
		local f = netfunctions.functions[ um:ReadString() ]
		if ( !f ) then return end
		
		local args, i, t = {}, 1, um:ReadChar()
		while ( t != 0 ) do
			args[i] = types[types[t]][3]( um )
			
			t = um:ReadChar()
			i = i + 1
		end
		
		f( unpack( args ) )
	end )
	
	function netfunctions.Register( name, func )
		netfunctions.functions[name] = func
	end
end

// Demo
if ( SERVER ) then
	netfunctions.Call( Entity(1), "printArgs", "overv", "is", 1337, "or", "1337" )
elseif ( CLIENT ) then
	netfunctions.Register( "printArgs", function( ... )
		for _, arg in ipairs( { ... } ) do
			Msg( type( arg ) .. "\t" .. tostring( arg ) .. "\n" )
		end
	end )
end
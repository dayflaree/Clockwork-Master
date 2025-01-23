/*-------------------------------------------------------------------------------------------------------------------------
	Shared functions
-------------------------------------------------------------------------------------------------------------------------*/

function store.ItemStringToTable( str )
	local t = string.Explode( ",", str )
	if ( #t[#t] == 0 ) then table.remove( t, #t ) end
	for k, v in ipairs( t ) do t[k] = tonumber( v ) end
	
	return t or {}
end

function store.ItemTableToString( str )
	return table.concat( str, "," )
end

function store.CalculateSellPrice( price )
	return math.floor( price * 0.6 / 25 ) * 25
end

function store.DefaultModel( ply )
	local m = player_manager.TranslatePlayerModel( ply:GetInfo( "cl_playermodel" ) )
	
	for _, item in ipairs( store.models ) do
		if ( item.model:lower() == m:lower() and !table.HasValue( SERVER and ply.store.models or store.ownedmodels, item.id ) ) then return "models/player/kleiner.mdl" end
	end
	
	return m
end
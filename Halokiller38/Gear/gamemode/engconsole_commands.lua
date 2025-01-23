
local function ccEngRequestUserInfo( ply, cmd, arg )

	if( not tonumber( arg[1] ) ) then return; end
	
	if( not ply:IsAdmin() ) then return; end

	local i = tonumber( arg[1] );
	
	local target = player.GetByID( i );
	
	if( target:IsValid() ) then
	
		umsg.Start( "RUI", ply );
			umsg.String( target:SteamID() );
		umsg.End();
	
	end

end
concommand.Add( "rui", ccEngRequestUserInfo );
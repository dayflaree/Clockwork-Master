function SendProcessedItems( ply )

	local delay = 0;

	for k, v in pairs( TS.ProcessedItems ) do
	
		local function AddEachItem( ply, v )
		
			local ID = v.ID or "";
			local Name = v.Name or "";
			local Desc = v.Description or "";
			local Model = v.Model or "";
			local Price = tostring(v.Price) or 1;
			local Width = v.Width or 1;
			local Height = v.Height or 1;
			local FOV = v.FOV or 10;
			local CamPos = v.CamPos or Vector( 0, 0, 0 );
			local LookAt = v.LookAt or Vector( 0, 0, 0 );

			umsg.Start( "GID", ply );
				umsg.String( ID );
				umsg.String( Name );
				umsg.String( Desc );
				umsg.String( Model );
				umsg.String( Price );
				umsg.Short( Width );
				umsg.Short( Height );
				umsg.Short( FOV );
				umsg.Vector( CamPos );
				umsg.Vector( LookAt );
			umsg.End();
			
		end
	
		timer.Simple( delay, AddEachItem, ply, v );
		delay = delay + .2;
		
	end

end

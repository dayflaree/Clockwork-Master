
local meta = FindMetaTable( "Player" );

function meta:FirstTimeSpawnHelp()

	local dotip = function( ply, text )
	
		if( ply and ply:IsValid() ) then
	
			ply:NoticePlainWhiteEx( text );
	
		end
	
	end

	timer.Simple( 10, dotip, self, "For help, press F1." );
	timer.Simple( 15, dotip, self, "Press F3 for your player menu and inventory." );
	timer.Simple( 20, dotip, self, "Press F4 to recognize another player." );
	timer.Simple( 25, dotip, self, "Press the use-key on an item to interact with it." );
	timer.Simple( 32, dotip, self, "Use SHIFT + ALT to sprint at full speed." );

end

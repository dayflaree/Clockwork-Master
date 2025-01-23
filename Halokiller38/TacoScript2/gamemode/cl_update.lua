UnconsciousTime = 0;

function OnUpdatePlayerHolstered( oldb, b )

	if( SeeSniperScope ) then
	
		RunConsoleCommand( "eng_seescope", "0" );
		SeeSniperScope = false;

	end

end

function OnUpdatePlayerConscious( oldb, b ) 

	if( b ) then
	
		CinematicBarDesiredHeight = 0;
	
	else
	
		CinematicBarDesiredHeight = 120;
		UnconsciousTextAlpha = 0;
		UnconsciousTime = CurTime();
		UnconsciousViewPos = nil;
		UnconsciousViewAng = nil;
	
	end

end 

surface.CreateFont( "Bebas", 20, 500, true, false, "PBText" );

ProgressBars = { }
ProgressYPos = ScrH() / 2 - 100;

function CreateProgressBar( id, text, duration )

	surface.SetFont( "NoticeText" );

	ProgressBars[id] = {
		
		id = id,
		Text = text,
		Duration = duration,
		StartTime = CurTime(),
		y = ProgressYPos,
		TextLen = surface.GetTextSize( text ),
	
	};

end

function msgs.RPB( msg )

	local id = msg:ReadString();
	
	ProgressBars[id] = nil;

end

function msgs.CPB( msg )

	local id = msg:ReadString();
	local text = msg:ReadString();
	local duration = msg:ReadFloat();
	
	CreateProgressBar( id, text, duration );

end

function DrawProgressBars()

	for k, v in pairs( ProgressBars ) do
	
		local timepassed = CurTime() - v.StartTime;
	
		draw.RoundedBox( 0, ScrW() / 2 - 150, v.y, v.TextLen + 7, 30, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 0, ScrW() / 2 - 150, v.y + 19, 300, 25, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 0, ScrW() / 2 - 148, v.y + 21, 296, 21, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 0, ScrW() / 2 - 146, v.y + 23, 292 * math.Clamp( timepassed / v.Duration, 0, 1 ), 17, Color( 255, 255, 255, 255 ) );
		
		draw.DrawText( v.Text, "NoticeText", ScrW() / 2 - 147, v.y + 1, Color( 0, 0, 0, 255 ) );
		
	end

end
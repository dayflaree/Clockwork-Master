
surface.CreateFont( "Bebas", 18, 500, true, false, "NoticeText" );

Notices = { }
NoticeCount = 0;
NoticeYPos = 20;

function CreateNotice( text, color, duration )

	if( NoticeCount == 0 ) then
	
		NoticeYPos = 30;
	
	end

	table.insert( Notices,
		
		{
		
			Text = string.gsub( text, " ", "   " ),
			Color = color,
			StartTime = CurTime(),
			EndTime = duration + CurTime(),
			Alpha = 0,
			y = NoticeYPos,
			
		}
	
	);
	
	NoticeYPos = NoticeYPos + 20;
	NoticeCount = NoticeCount + 1;

end

function DrawNotices()

	for k, v in pairs( Notices ) do
	
		v.Color.a = v.Alpha;
		draw.DrawText( v.Text, "NoticeText", ScrW() - 15, v.y, v.Color, 2, 0 );
		
		if( CurTime() < v.EndTime ) then
		
			v.Alpha = math.Clamp( v.Alpha + 300 * FrameTime(), 0, 255 );
			
		else
		
			v.Alpha = v.Alpha - 250 * FrameTime();
			
			if( v.Alpha < 0 ) then
				
				Notices[k] = nil;
				NoticeCount = NoticeCount - 1;
			
			end
		
		end
	
	end

end

function msgs.nPLAINWHITEEX( msg )

	local str = msg:ReadString();
	
	CreateNotice( str, Color( 255, 255, 255, 255 ), 8 );

end

function msgs.nPLAINWHITE( msg )

	local str = msg:ReadString();
	
	CreateNotice( str, Color( 255, 255, 255, 255 ), 5 );

end

function msgs.nRECITEM( msg )

	local str = msg:ReadString();
	
	CreateNotice( str, Color( 70, 180, 70, 255 ), 4 );

end


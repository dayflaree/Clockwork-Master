
function CreateActionMenu( ent )

	ActionMenu = { 
	
		Entity = ent,
		Options = { },
		ypos = 0,
		Width = 0,
		Height = 28,
		Alpha = 255,
		TracePos = LocalPlayer():GetEyeTrace().HitPos,
	
	};

end 

function KillActionMenu()

	ActionMenu = nil;

end

function msgs.CAM( msg )

	local ent = msg:ReadEntity();

	CreateActionMenu( ent );
	
	ActionMenu.OptionCount = msg:ReadShort();

end

function msgs.AAMC( msg )

	if( not ActionMenu ) then return; end

	local count = math.Clamp( ActionMenu.OptionCount - #ActionMenu.Options, 0, 4 );
	
	for n = 1, count do

		local text = msg:ReadString();
		local cmd = msg:ReadString();
		
		text = string.gsub( text, " ", "   " );
		
		if( cmd == "nil" ) then
			cmd = nil;
		end
		
		surface.SetFont( "ActionMenuOption" );
		local w, h = surface.GetTextSize( text );
		
		if( w > ActionMenu.Width - 15 ) then
		
			ActionMenu.Width = w + 15;
		
		end
		
		table.insert( ActionMenu.Options, { Width = w, Height = h, Text = text, Cmd = cmd, y = ActionMenu.ypos } );
		
		ActionMenu.Height = ActionMenu.Height + h + 2;
		ActionMenu.ypos = ActionMenu.ypos + 20;
		
	end

end

surface.CreateFont( "Bebas", 16, 400, true, false, "ActionMenuOption" );

function DrawActionMenu()

	if( not ActionMenu ) then return; end
	if( not ActionMenu.Entity or not ActionMenu.Entity:IsValid() ) then ActionMenu = nil; return; end
	
	local ent = ActionMenu.Entity;
	local pos = ActionMenu.TracePos;
	local scrpos = pos:ToScreen();
	
	scrpos.x = scrpos.x + 60;

	draw.RoundedBox( 0, scrpos.x, scrpos.y, ActionMenu.Width, ActionMenu.Height, Color( 255, 255, 255, ActionMenu.Alpha ) );
	draw.RoundedBox( 0, scrpos.x + 3, scrpos.y + 3, ActionMenu.Width - 6, ActionMenu.Height - 6, Color( 0, 0, 0, ActionMenu.Alpha ) );
	
	for k, v in pairs( ActionMenu.Options ) do
	
		if( v.Cmd ) then
		
			if( ScreenCenterInArea( scrpos.x + 8, scrpos.y + 8 + v.y - v.Height, v.Width, v.Height ) ) then
		
				draw.DrawText( v.Text, "ActionMenuOption", scrpos.x + 8, scrpos.y + 8 + v.y, Color( 180, 180, 180, ActionMenu.Alpha ) );
				
				if( input.IsMouseDown( MOUSE_LEFT ) or SimulatedMouseClick ) then
				
					SimulatedMouseClick = false;
				
					local tbl = string.Explode( " ", v.Cmd );
					
					local cmd = tbl[1];
					local arg = tbl[2] or "";
				
					if( string.sub( cmd, 1, 1 ) == "#" ) then
					
						_G[string.sub( cmd, 2 )]();
					
					else
					
						RunConsoleCommand( cmd, arg );
						
					end
					
					KillActionMenu();
					return;
				
				end
				
			else
		
				draw.DrawText( v.Text, "ActionMenuOption", scrpos.x + 8, scrpos.y + 8 + v.y, Color( 255, 255, 255, ActionMenu.Alpha ) );
			
			end
			
		else
		
			draw.RoundedBox( 0, scrpos.x, scrpos.y + v.y + 7, ActionMenu.Width, 18, Color( 255, 255, 255, ActionMenu.Alpha ) );
			draw.DrawText( v.Text, "ActionMenuOption", scrpos.x + 8, scrpos.y + 8 + v.y, Color( 0, 0, 0, ActionMenu.Alpha ) );
		
		end
	
	end
	
	draw.DrawTextOutlined( "+", "NoticeText", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, ActionMenu.Alpha ) );
	
	if( not ScreenCenterInArea( scrpos.x - 200, scrpos.y - 200, ActionMenu.Width + 400, ActionMenu.Height + 400 ) or
		( LocalPlayer():EyePos() - ActionMenu.TracePos ):Length() > 70 ) then
		
		ActionMenu.Alpha = math.Clamp( ActionMenu.Alpha - 250 * FrameTime(), 0, 255 );
		
		if( ActionMenu.Alpha <= 0 ) then
		
			KillActionMenu();
			return;
		
		end
		
	elseif( ActionMenu.Alpha < 255 ) then
	
		ActionMenu.Alpha = math.Clamp( ActionMenu.Alpha + 220 * FrameTime(), 0, 255 );
	
	end
	
	if( input.IsMouseDown( MOUSE_LEFT ) ) then
	
		KillActionMenu();
		return;
	
	end
	
end



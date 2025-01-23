--Scoreboard optimized and cleaned - 26/May/10
--This was supposed to be temporary, but meh.

surface.CreateFont( "coolvetica", 28, 400, true, false, "HorseyFont" );

if( ScoreboardFrame ) then

	ScoreboardFrame:Remove();
	
end

ScoreboardFrame = nil;

function CreateScoreboard()

	ScoreboardFrame = CreateBPanel( nil, ScrW()/2 - 250, ScrH()/2 - (ScrH()*0.7*0.5), 500, ScrH()*0.7 );
	ScoreboardFrame:CanClose( false );
	ScoreboardFrame:CanDrag( false );
	ScoreboardFrame:SetBodyColor( Color( 50, 50, 50, 100 ) );
	
	ScoreboardFrame.PaintHook = function()
	
		draw.DrawTextOutlined( "Excision Gaming HL2RP", "GModToolName", 10, 2, Color( 255, 255, 255, 255 ), nil, nil, 2, Color( 0, 0, 0, 255 ) );
		
	end
	
	ScoreboardFrame.Inner = CreateBPanel( nil, 5, 25, 490, ScrH()*0.7-50 );
	ScoreboardFrame.Inner:SetParent( ScoreboardFrame )
	ScoreboardFrame.Inner:CanClose( false );
	ScoreboardFrame.Inner:CanDrag( false );
	ScoreboardFrame.Inner:SetBodyColor( Color( 30, 30, 30, 240 ) );
	ScoreboardFrame.Inner:EnableScrolling( true );
	
	ScoreboardFrame.Inner.PlayerRow = { }
	ScoreboardFrame.Inner.PlayerIcons = { }
	
	local sy = 0;
	local name;
	
	for t, n in pairs( team.GetAllTeams() ) do
	
		if( team.NumPlayers( t ) > 0 ) then
		
			ScoreboardFrame.Inner:AddLabel( team.GetName( t ), "HorseyFont", 2, sy + 3, Color( 255, 255, 255, 255 ) );
	
			sy = sy + 22;

			for k, v in pairs( player.GetAll() ) do
			
				if( team.GetName( v:Team() ) == team.GetName( t )  )then

					ScoreboardFrame.Inner.PlayerRow[v] = CreateBPanel( nil, 0, sy - 21, ScoreboardFrame.Inner:GetWide() - 15, 73 );
					ScoreboardFrame.Inner.PlayerRow[v]:SetParent( ScoreboardFrame.Inner );
					ScoreboardFrame.Inner.PlayerRow[v]:SetBodyColor( Color( 50, 50, 50, 255 ) );

					ScoreboardFrame.Inner.PlayerRow[v].Paint = function()
					
						if( v:IsValid() ) then

							if( not v:GetRPName() or v:GetRPName() == "" ) then
	
								name = v:Name() .. " - Connecting";
		
							else
	
								name = v:GetRPName();
	
							end

							draw.DrawText( name or "", "NewChatFont", 76, 10, Color( 255, 255, 255, 255 ) );
							draw.DrawText( v:Ping(), "NewChatFont", ScoreboardFrame.Inner:GetWide() - 50, 10, Color( 255, 255, 255, 255 ) );
							draw.DrawText( v:GetTitle() .. "\n" .. v:GetTitle2(), "NewChatFont", 76, 24, Color( 200, 200, 200, 255 ) );
	
						end
						
					end

					ScoreboardFrame.Inner.PlayerIcons[v] = vgui.Create( "SpawnIcon", ScoreboardFrame.Inner );
					ScoreboardFrame.Inner.PlayerIcons[v]:SetPos( 6, sy + 10 );
					ScoreboardFrame.Inner.PlayerIcons[v]:SetSize( 64, 64 );
					ScoreboardFrame.Inner.PlayerIcons[v]:SetModel( v:GetModel() );
					ScoreboardFrame.Inner.PlayerIcons[v]:SetMouseInputEnabled( false );

					sy = sy + 70;

					ScoreboardFrame.Inner:AddObject( ScoreboardFrame.Inner.PlayerRow[v] );
					ScoreboardFrame.Inner:AddObject( ScoreboardFrame.Inner.PlayerIcons[v] );
					
				end
				
			end
			
		end
		
	end

end

function GM:ScoreboardShow()

	CreateScoreboard();
	
	gui.EnableScreenClicker( true );
	
end

function GM:ScoreboardHide()

	if( ScoreboardFrame ) then

		ScoreboardFrame:Remove();
		
	end
	
	HideMouse();

end
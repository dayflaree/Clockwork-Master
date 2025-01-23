
surface.CreateFont( "Type-Ra", 18, 400, true, false, "ScoreboardText" );

local ScoreboardTitles = { }

function AddScoreboardTitle( steamid, text, color )

	ScoreboardTitles[steamid] = { Text = text, Color = color };

end

Scoreboard = nil;

local Avatars = { }

function AddAvatar( ply )
	
	local id = ply:SteamID();
	
	Avatars[id] = vgui.Create( "AvatarImage" );
	Avatars[id]:SetParent( Scoreboard.ContentPanel );
	Avatars[id]:SetPlayer( ply );
	Avatars[id]:SetSize( 32, 32 );

end

function RemoveAvatar( ply )
	
	local id = ply:SteamID();
	
	if( Avatars[id] and Avatars[id]:IsValid() ) then
	
		Avatars[id]:Remove();
		Avatars[id] = nil;
	
	end

end

function ResizeScoreboard()

	local excess = 0;

	if( Scoreboard.DesiredHeight > ScrH() - 100 ) then
	
		excess = Scoreboard.DesiredHeight - ( ScrH() - 100 );
		
		Scoreboard.DesiredHeight = ScrH() - 100;
	
	end

	local lowy = Scoreboard.ContentPanel.LowestY;

	Scoreboard:SetPos( ScrW() * .5 - 250, ScrH() * .5 - 50 - Scoreboard.DesiredHeight * .5 );
	Scoreboard:SetSize( Scoreboard:GetWide(), Scoreboard.DesiredHeight );
	Scoreboard.ContentPanel:SetSize( Scoreboard:GetWide() - 20, Scoreboard:GetTall() - 100 );
	Scoreboard.ContentPanel.BottomY = Scoreboard.DesiredHeight;
	Scoreboard.ContentPanel.LowestY = Scoreboard.DesiredHeight + excess;

	if( Scoreboard.ContentPanel.LowestY ~= lowy and excess > 0 ) then
	
		Scoreboard.ContentPanel.VScrollDistance = excess;
		
		if( Scoreboard.ContentPanel.ScrollBarEnabled ) then
		
			Scoreboard.ContentPanel:CalculateScrollBar();
			
		end
		
	end
	

end

function DrawScoreboardContent()

	local y = 1;

	local mx, my = gui.MousePos();

	for k, v in pairs( player.GetAll() ) do
		
		if( Avatars[v:SteamID()] ) then
			
			Avatars[v:SteamID()]:SetPos( 5, y - Scoreboard.ContentPanel.VScrollAmount );
			
		end
		
		local nick = v:Nick();
		
		if( string.len( nick ) > 20 ) then
		
			nick = string.sub( nick, 1, 20 );
			nick = nick .. "..";
		
		end
		
		local nickwidth = 0;
		
		surface.SetFont( "ScoreboardText" );
		nickwidth = surface.GetTextSize( nick );
		
		local px, py = Scoreboard:GetPos();
		local p2x, p2y = Scoreboard.ContentPanel:GetPos();
		
		local dx = px + p2x;
		local dy = py + p2y;
		
		local cursorin = CursorInArea( dx + 5, dy + y - Scoreboard.ContentPanel.VScrollAmount, Scoreboard.ContentPanel:GetWide() - 20, 32 );
		
		if( v.SteamID == LocalPlayer():SteamID() or cursorin ) then
		
			draw.RoundedBox( 2, 5, y - Scoreboard.ContentPanel.VScrollAmount + 1, Scoreboard.ContentPanel:GetWide() - 20, 30, Color( 255, 255, 255, 15 ) );
			draw.RoundedBox( 2, 5, y - Scoreboard.ContentPanel.VScrollAmount + 1, Scoreboard.ContentPanel:GetWide() - 20, 10, Color( 255, 255, 255, 5 ) );
	
			if( cursorin and ( not ScoreboardInfoPanel or not ScoreboardInfoPanel:IsValid() ) ) then
	
				if( CursorLeftClickUp() ) then
				
					CreateScoreboardInfo( v );
					
				end
				
			end
	
		end

		draw.DrawText( nick, "ScoreboardText", 40, y + 5 - Scoreboard.ContentPanel.VScrollAmount, Color( 255, 255, 255, 255 ) );
		draw.DrawText( v:Ping() .. " MS", "ScoreboardText", 420, y + 5 - Scoreboard.ContentPanel.VScrollAmount, Color( 255, 255, 255, 255 ) );
	
		if( ScoreboardTitles[v:SteamID()] ) then
		
			draw.DrawText( ScoreboardTitles[v:SteamID()].Text, "ScoreboardText", 44 + nickwidth, y + 5 - Scoreboard.ContentPanel.VScrollAmount, ScoreboardTitles[v.SteamID].Color );
		
		end

		y = y + 30;
		
	end

end

function GM:CreateScoreboard()

	Scoreboard = CreateBPanel( nil, ScrW() * .5 - 250, ScrH() * .5 - 50, 500, 100 );
	Scoreboard.BodyColor = Color( 0, 0, 0, 255 );
	Scoreboard.Rows = { }
	
 	Scoreboard:AddLabel( "Epidemic.", "OpeningEpidemic", 10, 5, Color( 255, 255, 255, 255 ) );
 	
 	Scoreboard.ContentPanel = CreateBPanel( nil, 10, 76, Scoreboard:GetWide() - 20, Scoreboard:GetTall() - 100 );
 	Scoreboard.ContentPanel:SetParent( Scoreboard );
 	Scoreboard.ContentPanel.BodyColor = Color( 70, 70, 70, 150 );
 	Scoreboard.ContentPanel.OutlineWidth = 1;
 	Scoreboard.ContentPanel:EnableScrolling( true );
 	
 	Scoreboard.Think = function()
 	
 		--FindPlayerListChanges();
		Scoreboard.DesiredHeight = 100 + ( #player.GetAll() * 30 );
		ResizeScoreboard();
 	
 	end
 
 	Scoreboard.PaintHook = function()
		
 		draw.DrawText( string.gsub( "Server: " .. GetHostName(), " ", "   " ), "OpeningEpidemicLinks", 10, 70, Color( 255, 255, 255, 255 ) );
 		draw.RoundedBox( 0, 10, 90, 480, 2, Color( 255, 255, 255, 255 ) ); 
 	
 	end
 	
 	Scoreboard.ContentPanel.PaintHook = function()
 	
 		DrawScoreboardContent();
 	
 	end
 
end


function GM:ScoreboardShow()

 	if( ScoreboardInfoPanel and ScoreboardInfoPanel:IsValid() and
 		ScoreboardInfoPanel.TextEntry and ScoreboardInfoPanel.TextEntry:IsValid() and ScoreboardInfoPanel.TextEntry:HasFocus() ) then
 	
 		return;
 		
 	end

	if( not Scoreboard ) then
	
		self:CreateScoreboard();
	
	end
	
	Scoreboard:SetVisible( true );
	
	for _, v in pairs( player.GetAll() ) do
		
		AddAvatar( v );
		
	end
	
	gui.EnableScreenClicker( true );

end

AttemptCloseScoreboard = false;

function GM:ScoreboardHide( bypass )
 
 	if( not bypass and ScoreboardInfoPanel and ScoreboardInfoPanel:IsValid() and
 		ScoreboardInfoPanel.TextEntry and ScoreboardInfoPanel.TextEntry:IsValid() and ScoreboardInfoPanel.TextEntry:HasFocus() ) then
 		
 		AttemptCloseScoreboard = true;
 		return;
 		
 	end
 
	Scoreboard:SetVisible( false );
	
	for _, v in pairs( player.GetAll() ) do
		
		RemoveAvatar( v );
		
	end
	
	Avatars = { };
	
	if( ScoreboardInfoPanel and ScoreboardInfoPanel:IsValid() ) then
	
		ScoreboardInfoPanel:Remove();
		ScoreboardInfoPanel = nil;
	
	end
	
	HideMouse();
 
end
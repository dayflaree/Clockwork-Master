
ScoreboardInfoPanel = nil;

ScoreboardPlayerInfo = { }

NextCanSetScoreboardDesc = 0;
NextCanRequestScoreboardInfo = 0;
DisabledSetScoreboardDesc = false;
NoScoreboardInfo = false;

function AddScoreboardInfoForPlayer( steamid, date, desc, infkilled, humkilled, diedc, banc, kickc )

	ScoreboardPlayerInfo[steamid] = {
	
		Date = date,
		Desc = desc,
	
	};

end 

function CreateScoreboardInfo( ply )

	if( ScoreboardInfoPanel ) then
	
		ScoreboardInfoPanel:Remove();
	
	end
	
	ScoreboardInfoPanel = CreateBPanel( nil, ScrW() * .5 - 200, ScrH() * .5 - 90, 400, 180 );
	ScoreboardInfoPanel.OutlineWidth = 5;
	
	NoScoreboardInfo = true;

	ScoreboardInfoPanel.Think = function()
	
		if( not NoScoreboardInfo ) then return; end
	
		if( CurTime() > NextCanRequestScoreboardInfo ) then
		
			RunConsoleCommand( "eng_reqsbinfo", ply:EntIndex() );
			
			NoScoreboardInfo = false;
			NextCanRequestScoreboardInfo = CurTime() + 2;
		
		end
	
	end

	if( ply == LocalPlayer() ) then
	
		local px, py = ScoreboardInfoPanel:GetPos();
	
		ScoreboardInfoPanel.TextEntry = vgui.Create( "DTextEntry", ScoreboardInfoPanel );
		ScoreboardInfoPanel.TextEntry:SetMultiline( true );
		ScoreboardInfoPanel.TextEntry:SetPos( px + 15, py + 65 );
		ScoreboardInfoPanel.TextEntry:SetSize( 370, 50 );
		ScoreboardInfoPanel.TextEntry:MakePopup();
	
		ScoreboardInfoPanel.TextEntry:SetValue( ClientVars["SBTitle"] );
	
		ScoreboardInfoPanel.Set = ScoreboardInfoPanel:AddButton( "Set", 350, 118, function()
		
			if( CurTime() > NextCanSetScoreboardDesc ) then
			
				NextCanSetScoreboardDesc = CurTime() + 3;
				ScoreboardInfoPanel.Set:SetPos( 330, 118 );
				ScoreboardInfoPanel.Set:SetText( "Saving.." );
				DisabledSetScoreboardDesc = true;
				
				RunConsoleCommand( "eng_setsbdesc", ScoreboardInfoPanel.TextEntry:GetValue() );
			
			end
		
		end );
	
		ScoreboardInfoPanel.Set.ThinkHook = function()
	
			if( DisabledSetScoreboardDesc and CurTime() > NextCanSetScoreboardDesc ) then
			
				ScoreboardInfoPanel.Set:SetText( "Set" );
				ScoreboardInfoPanel.Set:SetPos( 350, 118 );
				DisabledSetScoreboardDesc = false;
				
			end
		
		end
	
	end
	
	ScoreboardInfoPanel:AddButton( "Copy to clipboard", 265, 30, function()
	
		SetClipboardText( ply:SteamID() );
	
	end );
	
	ScoreboardInfoPanel.Avatar = vgui.Create( "AvatarImage", ScoreboardInfoPanel );
	ScoreboardInfoPanel.Avatar:SetPos( 15, 15 );
	ScoreboardInfoPanel.Avatar:SetSize( 32, 32 );
	ScoreboardInfoPanel.Avatar:SetPlayer( ply );
	
	ScoreboardInfoPanel.Close = ScoreboardInfoPanel:AddLink( "X", "ButtonFont", 373, 7, Color( 128, 128, 128, 255 ), 
	
	
	function() 
	
		ScoreboardInfoPanel:Remove(); 
		ScoreboardInfoPanel = nil; 
		
		if( AttemptCloseScoreboard ) then
		
			GAMEMODE:ScoreboardHide( true );
			AttemptCloseScoreboard = false;
		
 		end

	end,

	Color( 255, 255, 255, 255 ) );
	
	ScoreboardInfoPanel.PaintHook = function()
	
		if( not ply or not ply:IsValid() ) then
		
			ScoreboardInfoPanel:Remove();
			ScoreboardInfoPanel = nil;
			return;
		
		end
		
		if( not ScoreboardPlayerInfo[ply:SteamID()] ) then
		
			AddScoreboardInfoForPlayer( ply:SteamID(), "", "", 0, 0, 0, 0, 0 );
		
		end
	
		local desc = "";
	
		desc = ScoreboardPlayerInfo[ply:SteamID()].Desc;
	
		draw.DrawText( ply:Nick(), "ScoreboardText", 55, 15, Color( 255, 255, 255, 255 ) );
		draw.DrawText( ply:SteamID(), "ScoreboardText", 55, 30, Color( 255, 255, 255, 255 ) );
		
		local pdy = 0;
		
		if( LocalPlayer() ~= ply ) then
		
			draw.DrawText( desc, "ScoreboardText", 15, 55, Color( 255, 255, 255, 255 ) );
		
			surface.SetFont( "ScoreboardText" );
			local _, height = surface.GetTextSize( desc );
			
			if( ScoreboardInfoPanel:GetTall() - 65 ~= height ) then
			
				ScoreboardInfoPanel:SetPos( ScrW() * .5 - 200, ScrH() * .5 - ( height + 205 ) * .5 );
				ScoreboardInfoPanel:SetSize( 400, height + 205 );
				
			end
		
			pdy = height + 55;
		
		else
		
			pdy = 135;
		
		end
		
		if( ScoreboardInfoPanel.TextEntry and ScoreboardInfoPanel.TextEntry:IsValid() ) then
		
			local color = Color( 255, 255, 255, 255 );
			
			if( string.len( ScoreboardInfoPanel.TextEntry:GetValue() ) > 200 ) then
			
				color = Color( 255, 0, 0, 255 );
			
			end
		
			draw.DrawText( string.len( ScoreboardInfoPanel.TextEntry:GetValue() ) .. " / 200 characters", "ButtonFont", 15, pdy - 10, color );
		
		end
		
		draw.RoundedBox( 0, 15, pdy + 10, 370, 2, Color( 255, 255, 255, 255 ) );
		
		draw.DrawText( "FIRST  JOINED:   " .. ScoreboardPlayerInfo[ply:SteamID()].Date, "ButtonFont", 15, pdy + 15, Color( 255, 255, 255, 255 ) );
		
	end
	
end
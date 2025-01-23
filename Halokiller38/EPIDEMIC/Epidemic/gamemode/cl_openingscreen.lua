
surface.CreateFont( "Bebas", 72, 800, true, false, "OpeningEpidemic" );
surface.CreateFont( "Bebas", 36, 800, true, false, "OpeningEpidemicSubtitle" );
surface.CreateFont( "Bebas", 18, 400, true, false, "OpeningEpidemicLinks" );

BlackScreenOn = true;
FirstBlackScreen = false;
FirstBlackScreenAlpha = 255;

local year = "2013";

local MapAreas = { }

MapAreas["rp_necro_pough"] = "Poughkeepsie.  " .. year .. ".";
MapAreas["rp_necro_torrington"] = "Torrington.  " .. year .. ".";
MapAreas["rp_necro_torrington_day"] = "Torrington.  " .. year .. ".";
MapAreas["rp_necro_drainage"] = "Drainage  canals.  " .. year .. ".";
MapAreas["rp_necro_highway"] = "An  unnamed  highway.  " .. year .. ".";
MapAreas["rp_necro_outskirts"] = "Torrington  trainyard.  " .. year .. ".";

OpeningScreen = { 

	HUDOverride = false,
	HUDPrevent = true,
	Subtitle = "New York City.  " .. year .. ".",
	StartTime = 0,
	TitleAlpha = 0,
	SubtitleAlpha = 0,
	FadeOut = false,
	CharacterSaves = { },

}

if( MapAreas[GetMap()] ) then
	
	OpeningScreen.Subtitle = MapAreas[GetMap()];
	
end

function event.DoOpenScene()
	
	DeveloperProcess = 1;
	DeveloperText = { };
	Developerxpos = 25;
	
	if( PlayerMenuPanel and PlayerMenuPanel:IsVisible() ) then
	
		event.TogglePM();
	
	end
	
	if( HelpMenu.Panel and HelpMenu.Panel:IsVisible() ) then
		
		HelpMenu.Panel:Remove();
	
	end
	
	FirstBlackScreen = true;
	OpeningScreen.HUDOverride = true;
	OpeningScreen.HUDPrevent = true;
	OpeningScreen.FadeOut = false;
	OpeningScreen.StartTime = CurTime();
	
	if( not OpeningScreen.Ambience ) then
		OpeningScreen.Ambience = CreateSound( LocalPlayer(), "ambient/atmosphere/tone_alley.wav" );
	end
	
	OpeningScreen.Ambience:Stop();
	
	OpeningScreen.TitleAlpha = 0;
	OpeningScreen.SubtitleAlpha = 0;
	OpeningScreen.CreatedMenuButtons = false;
	OpeningScreen.CreatedClassMenu = false;
	OpeningScreen.CreatedCharSave = false;
	
	OpeningScreen.ClassLink = { }
	OpeningScreen.CharSaveLink = { }
	OpeningScreen.CharacterSaves = { }
	OpeningScreen.DeleteLink = { }
	
	IntroViewHook = true;

end

function event.DoOpenSceneNoFade()

	event.DoOpenScene();
		
	OpeningScreen.StartTime = CurTime() - 3.8;
	OpeningScreen.TitleAlpha = 255;
	OpeningScreen.SubtitleAlpha = 255;

end

function event.FadeOutOpeningScene()

	OpeningScreen.FadeOut = true;

	if( OpeningScreen.CreateLink ) then

		OpeningScreen.CreateLink:FadingOut( 150 );
		
	end
	
	if( OpeningScreen.SaveError ) then
	
		OpeningScreen.SaveError:FadingOut( 150 );
	
	end
		
	if( OpeningScreen.ChooseLink ) then
		
		OpeningScreen.ChooseLink:FadingOut( 150 );
		
	end
	
	if( OpeningScreen.CancelLink ) then
	
		OpeningScreen.CancelLink:FadingOut( 150 );
	
	end
	
	for k, v in pairs( OpeningScreen.ClassLink ) do
	
		OpeningScreen.ClassLink[k]:FadingOut( 150 );
	
	end	
	
	for k, v in pairs( OpeningScreen.DeleteLink ) do
	
		OpeningScreen.DeleteLink[k]:FadingOut( 150 );
		
	end

	for k, v in pairs( OpeningScreen.CharSaveLink ) do
	
		OpeningScreen.CharSaveLink[k]:FadingOut( 150 );
	
	end

end

function event.KillOpenScene()

	OpeningScreen.HUDOverride = false;

	FirstBlackScreen = false;
	BlackScreenOn = false;
	
	if( OpeningScreen.CreateLink ) then

		OpeningScreen.CreateLink:Remove();
		OpeningScreen.CreateLink = nil;
		
	end
		
	if( OpeningScreen.ChooseLink ) then
		
		OpeningScreen.ChooseLink:Remove();
		OpeningScreen.ChooseLink = nil;
		
	end
	
	if( OpeningScreen.CancelLink ) then
	
		OpeningScreen.CancelLink:Remove();
		OpeningScreen.CancelLink = nil;
	
	end
	
	if( OpeningScreen.SaveError ) then

		OpeningScreen.SaveError:Remove();
		OpeningScreen.SaveError = nil;
		
	end
	
	for k, v in pairs( OpeningScreen.ClassLink ) do
	
		v:Remove();
		OpeningScreen.ClassLink[k] = nil;
	
	end
	
	for k, v in pairs( OpeningScreen.DeleteLink ) do
	
		v:Remove();
		OpeningScreen.DeleteLink[k] = nil;
	
	end
	
	for k, v in pairs( OpeningScreen.CharSaveLink ) do
	
		v:Remove();
		OpeningScreen.CharSaveLink[k] = nil;
	
	end

end

function OpeningScreen.CreateClassMenu()

	local num = 1;

	for k, v in pairs( PlayerGroups ) do
	
		local addgroup = false;
		
		if( v.Default ) then
		
			addgroup = true;
		
		else
		
			if( string.find( ClientVars["Flags"], v.FlagsRequired ) ) then
			
				addgroup = true;
			
			end
		
		end
		
		if( addgroup ) then
	
			OpeningScreen.ClassLink[k] = vgui.CreateLink();
			OpeningScreen.ClassLink[k]:SetPos( ScrW() * .25 + 50, ScrH() * .5 + 20 + ( ( num - 1 ) * 15 ) );
			OpeningScreen.ClassLink[k]:SetText( v.Name, "OpeningEpidemicLinks", true );
			OpeningScreen.ClassLink[k].Action = function()
			
				if( OpeningScreen.MaxCharsReached ) then
				
					CreateOkPanel( "Cannot create new character", "You've reached the max limit of 20." );
				
				else
			
					CharacterCreateMenu( k );
			
				end
			
			end
			
			num = num + 1;
		
		end
		
	end	
	
end

function msgs.MCL( msg )

	local b = msg:ReadBool();
	
	OpeningScreen.MaxCharsReached = b;

end

function LoadCharacterSave( id )

	RunConsoleCommand( "eng_choosechar", id );
	
	event.FadeOutOpeningScene();
	
	CharacterCreate.FinishEffect = true;
	CharacterCreate.FinishAlpha = 0;
	CharacterCreate.FinishStart = CurTime();
	CharacterCreate.StartTime = CurTime();
	CharacterCreate.FadingEnd = false;
	
	CharacterCreate.FinishBrightness = .3;
	CharacterCreate.FinishContrast = 4.86;
	CharacterCreate.FinishColorMod = 0;
	

end

function OpeningScreen.CreateCharacterSavesList()

	OpeningScreen.UpdateCharacterSavesList();

end

function OpeningScreen.UpdateCharacterSavesList()

	if( #OpeningScreen.CharacterSaves < 1 ) then
	
		OpeningScreen.SaveError = vgui.CreateLink();
		OpeningScreen.SaveError:SetPos( ScrW() * .75 + 50, ScrH() * .5 + 20 );
		OpeningScreen.SaveError:SetText( "No  saves  to  choose", "OpeningEpidemicLinks", true );
		OpeningScreen.SaveError.Action = function()
		
		end		
	
	elseif( OpeningScreen.SaveError ) then
	
		OpeningScreen.SaveError:Remove();
		OpeningScreen.SaveError = nil;
		
	end
	
	surface.SetFont( "OpeningEpidemicLinks" );

	for k, v in pairs( OpeningScreen.CharacterSaves ) do
	
		if( not OpeningScreen.CharSaveLink[k] ) then
	
			OpeningScreen.CharSaveLink[k] = vgui.CreateLink();
			OpeningScreen.CharSaveLink[k]:SetPos( ScrW() * .75 + 50, ScrH() * .5 + 20 + ( k - 1 ) * 20  );
			OpeningScreen.CharSaveLink[k]:SetText( v, "OpeningEpidemicLinks", true );
			OpeningScreen.CharSaveLink[k].Action = function()
			
				LoadCharacterSave( k );
			
			end
			
			local w = surface.GetTextSize( v );
			
			OpeningScreen.DeleteLink[k] = vgui.CreateLink();
			OpeningScreen.DeleteLink[k]:SetPos( ScrW() * .75 + 50 + w + 10, ScrH() * .5 + 20 + ( k - 1 ) * 20  );
			OpeningScreen.DeleteLink[k]:SetText( "Delete", "OpeningEpidemicLinks", true );
			OpeningScreen.DeleteLink[k].Action = function()
			
				local str = string.gsub( "Do you really want to delete: " .. v .. "?", " ", "  " );
				
				surface.SetFont( "ActionMenuOptionDesc" );
				local w = surface.GetTextSize( str ) + 30;
				
				local pnl = CreateBPanel( nil, ScrW() / 2 - w / 2, ScrH() / 2 - 150 / 2, w, 65 );
				pnl:AddLabel( str, "ActionMenuOptionDesc", 20, 5 );
				
				pnl:AddButton( "Yes", 20, 30, function()
		
					RunConsoleCommand( "eng_deletechar", k, 1 );
					
					OpeningScreen.CharacterSaves = { }
					
					OpeningScreen.CreatedCharSave = false;
					
					if( OpeningScreen.SaveError ) then
				
						OpeningScreen.SaveError:Remove();
						OpeningScreen.SaveError = nil;
						
					end
					
					for k, v in pairs( OpeningScreen.DeleteLink ) do
					
						v:Remove();
						OpeningScreen.DeleteLink[k] = nil;
					
					end
					
					for k, v in pairs( OpeningScreen.CharSaveLink ) do
					
						v:Remove();
						OpeningScreen.CharSaveLink[k] = nil;
					
					end
				
					pnl:Remove();
					
					gui.EnableScreenClicker( true );
				
				end );
				
				pnl:AddButton( "No", w - 40, 30, function()
				
					pnl:Remove();
					
					gui.EnableScreenClicker( true );
				
				end );
			
			end			
			
		end
	
	end

end

function msgs.ACL( msg )

	table.insert( OpeningScreen.CharacterSaves, msg:ReadString() );

	if( OpeningScreen.CreatedCharSave ) then
		OpeningScreen.UpdateCharacterSavesList();
	end	

end

function msgs.SCL( msg )

	local num = msg:ReadShort();
	
	for n = 1, num do
	
		table.insert( OpeningScreen.CharacterSaves, msg:ReadString() );
	
	end
	
	if( OpeningScreen.CreatedCharSave ) then
		OpeningScreen.UpdateCharacterSavesList();
	end
	
end

function event.UCL()

	OpeningScreen.CreatedCharSave = true;
	OpeningScreen.UpdateCharacterSavesList();

end

function OpeningScreen.DrawHUD()

	if( OpeningScreen.FadeOut ) then
	
		OpeningScreen.TitleAlpha = math.Clamp( OpeningScreen.TitleAlpha - 150 * FrameTime(), 0, 255 );
		OpeningScreen.SubtitleAlpha = math.Clamp( OpeningScreen.SubtitleAlpha - 150 * FrameTime(), 0, 255 );
		
		if( OpeningScreen.TitleAlpha <= 0 ) then
		
			event.KillOpenScene();
		
		end
		
	end

	local y =  ScrH() * .3;
	
	surface.SetFont( "OpeningEpidemic" );
	local w, h = surface.GetTextSize( "Epidemic." );
	
	local y2 = y + h + 5;
	
	draw.DrawText( "Epidemic.", "OpeningEpidemic", ScrW() / 2, y, Color( 255, 255, 255, OpeningScreen.TitleAlpha ), 1, 1 );
	draw.DrawText( OpeningScreen.Subtitle, "OpeningEpidemicSubtitle", ScrW() / 2, y2, Color( 255, 255, 255, OpeningScreen.SubtitleAlpha ), 1, 1 );

	if( CurTime() - OpeningScreen.StartTime > 2 ) then
	
		if( OpeningScreen.Ambience ) then
	
			OpeningScreen.Ambience:Play();
	
		end
	
		if( not OpeningScreen.FadeOut ) then
	
			OpeningScreen.TitleAlpha = math.Clamp( OpeningScreen.TitleAlpha + 100 * FrameTime(), 0, 255 );
	
		end
	
		if( CurTime() - OpeningScreen.StartTime > 3.3 ) then
		
			if( not OpeningScreen.FadeOut ) then
		
				OpeningScreen.SubtitleAlpha = math.Clamp( OpeningScreen.SubtitleAlpha + 100 * FrameTime(), 0, 255 );
		
			end
		
		end
		
		if( not OpeningScreen.CreatedMenuButtons and CurTime() - OpeningScreen.StartTime > 3.8 ) then
		
			gui.EnableScreenClicker( true );
		
			OpeningScreen.CreatedMenuButtons = true;
			
			if( ClientVars["CanLeaveCharacterCreate"] ) then
			
				OpeningScreen.CancelLink = vgui.CreateLink();
				OpeningScreen.CancelLink:FadingIn( 50 );
				OpeningScreen.CancelLink:SetPos( ScrW() * .5, ScrH() * .5 );
				OpeningScreen.CancelLink:SetText( "Cancel", "OpeningEpidemicLinks", true );
				
				OpeningScreen.CancelLink.Action = function()
				
					OpeningScreen.Ambience:Stop();
					RunConsoleCommand( "eng_cancelcc", "" );
					event.KillOpenScene();
					HideMouse();
					IntroViewHook = false;
				
				end				
			
			end
			
			OpeningScreen.CreateLink = vgui.CreateLink();
			OpeningScreen.CreateLink:FadingIn( 50 );
			OpeningScreen.CreateLink:SetPos( ScrW() * .25, ScrH() * .5 );
			OpeningScreen.CreateLink:SetText( "Create   A..", "OpeningEpidemicLinks", true );
			
			OpeningScreen.CreateLink.Action = function()
			
				if( not OpeningScreen.CreatedClassMenu ) then
			
					OpeningScreen.CreateClassMenu();
					OpeningScreen.CreatedClassMenu = true;
					
				end
			
			end
		
			OpeningScreen.ChooseLink = vgui.CreateLink();
			OpeningScreen.ChooseLink:FadingIn( 50 );
			OpeningScreen.ChooseLink:SetPos( ScrW() * .75, ScrH() * .5 );
			OpeningScreen.ChooseLink:SetText( "Choose..", "OpeningEpidemicLinks", true );
			
			OpeningScreen.ChooseLink.Action = function()
			
				if( not OpeningScreen.CreatedCharSave ) then
			
					OpeningScreen.CreateCharacterSavesList();
					OpeningScreen.CreatedCharSave = true;
					
				end				
			
			end
			
		end
	
	end
	
end

ButtFuckingDickSuckers = false;

function event.SERR()

	ButtFuckingDickSuckers = true;

end




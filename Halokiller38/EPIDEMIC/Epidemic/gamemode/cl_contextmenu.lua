HumanPoses = { }

HumanPoses[1] = {
	{ Text = "Idle - Normal", Cmd = "rp_setidleanim1" },
	{ Text = "Idle - Crossed", Cmd = "rp_setidleanim2" },
	{ Text = "Idle - Pockets", Cmd = "rp_setidleanim3" },
	{ Text = "Walk - Normal", Cmd = "rp_setwalkanim1" },
	{ Text = "Walk - Crossed", Cmd = "rp_setwalkanim2" },
	{ Text = "Crouch - Normal", Cmd = "rp_setcrouchanim1" },
	{ Text = "Crouch - Alert", Cmd = "rp_setcrouchanim2" },
	{ Text = "Crouch - Kneel", Cmd = "rp_setcrouchanim3" },
	{ Text = "", Cmd = "" },
	{ Text = "Sit - Ground", Cmd = "rp_sit" },
	{ Text = "Sit - Chair", Cmd = "rp_sitchair" },
	{ Text = "Lean", Cmd = "rp_lean" },
	{ Text = "Cheer", Cmd = "rp_cheer" },
	{ Text = "Examine", Cmd = "rp_examineanim" },
	{ Text = "Hands on Knees", Cmd = "rp_handsknees" },
	{ Text = "Lie on Ground", Cmd = "rp_lieonback" },
	{ Text = "Tinker - Kneel", Cmd = "rp_kneeltinker" },
	{ Text = "Wave", Cmd = "rp_wave" }
}

HumanPoses[2] = {
	{ Text = "Enter Code", Cmd = "rp_entercode" },
	{ Text = "Enter Code - Loop", Cmd = "rp_entercodeloop" },
	{ Text = "Signal - Advance", Cmd = "rp_signaladvance" },
	{ Text = "Signal - Forward", Cmd = "rp_signalforward" },
	{ Text = "Signal - Group", Cmd = "rp_signalgroup" },
	{ Text = "Signal - Halt", Cmd = "rp_signalhalt" },
	{ Text = "Signal - Left", Cmd = "rp_signalleft" },
	{ Text = "Signal - Right", Cmd = "rp_signalright" },
	{ Text = "Signal - Take Cover", Cmd = "rp_signaltakecover" },
}

HumanPoses[3] = {
	{ Text = "Idle - Normal", Cmd = "rp_setidleanim1" },
	{ Text = "Idle - Crossed", Cmd = "rp_setidleanim2" },
	{ Text = "Idle - Inquisitive", Cmd = "rp_setidleanim3" },
	{ Text = "Idle - Relaxed", Cmd = "rp_setidleanim4" },
	{ Text = "Crouch - Normal", Cmd = "rp_setcrouchanim1" },
	{ Text = "Crouch - Alert", Cmd = "rp_setcrouchanim2" },
	{ Text = "", Cmd = "" },
	{ Text = "Sit - Ground", Cmd = "rp_sit" },
	{ Text = "Lean", Cmd = "rp_lean" },
	{ Text = "Cheer", Cmd = "rp_cheer" },
	{ Text = "Tinker", Cmd = "rp_tinker" },
	{ Text = "Tinker - Kneel", Cmd = "rp_kneeltinker" },
	{ Text = "Kneel", Cmd = "rp_kneel" },
	{ Text = "Examine", Cmd = "rp_examineanim" },
	{ Text = "Calm Down", Cmd = "rp_calmdown" },
	{ Text = "Hands on Knees", Cmd = "rp_handsknees" },
	{ Text = "Wave", Cmd = "rp_wave" }
}

HumanPoses[19] = {
	{ Text = "Shove", Cmd = "rp_shove" },
	{ Text = "Push Button", Cmd = "rp_pushbutton" },
	{ Text = "Stop", Cmd = "rp_stop" },
	{ Text = "Point", Cmd = "rp_point" },
}

function FillUpContextCommands()
	
	EpContextPanel.Options = { };
	
	if( ClientVars["Ragdolled"] ) then
	
		table.insert( EpContextPanel.Options, { Text = "Get up", Cmd = "rp_getup" } );
	
	else
	
		table.insert( EpContextPanel.Options, { Text = "Passout", Cmd = "rp_passout" } );
	
	end
	
	local AnimTable = LocalPlayer():GetTable().AnimTable;
	if( AnimTable and HumanPoses[ AnimTable ] ) then
		
		table.insert( EpContextPanel.Options, { Text = "", Cmd = "" } );
		
		for k, v in pairs( HumanPoses[ AnimTable ] ) do
			
			table.insert( EpContextPanel.Options, { Text = v.Text, Cmd = v.Cmd } );
			
		end
		
	end
	
	if( ClientVars["Class"] == "Infected" ) then
		
		for _, v in pairs( InfSoundTypes ) do
			
			local t = nil;
			
			for k, s in pairs( InfSoundTranslate ) do
				
				if( LocalPlayer():ModelStr( k ) ) then
					
					t = s;
					
				end
				
			end
			
			if( t and InfectedSounds[v][t] ) then
				
				table.insert( EpContextPanel.Options, { Text = v, Cmd = "rp_inf" .. string.lower( v ) } );
				
			end
			
		end
		
		if( LocalPlayer():ModelStr( "bloodsucker" ) or
			LocalPlayer():ModelStr( "snork" ) ) then
			
			table.insert( EpContextPanel.Options, { Text = "Roar", Cmd = "rp_a_infroar" } );
			table.insert( EpContextPanel.Options, { Text = "Play Dead", Cmd = "rp_a_infplaydead" } );
			
		end

	end

end

function OpenEpidemicContextMenu()

	if( IRONSIGHTS_DEV ) then
	
		CreateIronSightsDev();
		return;
	
	end

	EpContextPanel = CreateBPanel( nil, ScrW() * .5, ScrH() * .5, 0, 0 );
	
	FillUpContextCommands();
	
	surface.SetFont( "ActionMenuOption" );
	
	local w = 0;
	local h = 0;
	
	--do two loops?	
	
	for k, v in pairs( EpContextPanel.Options ) do
	
		local tw = surface.GetTextSize( v.Text );
		
		if( tw > w ) then
		
			w = tw;
		
		end
		
		h = h + 18;
	
	end
	
	EpContextPanel:SetPos( ScrW() * .5 - w * .5 - 6, ScrH() * .5 - h * .5 );
	EpContextPanel:SetSize( w + 12, h + 8 );
	
	--we do this because we need to know how wide this panel is, which the first loop determines
	
	for k, v in pairs( EpContextPanel.Options ) do
	
		local tw = surface.GetTextSize( string.gsub( v.Text, " ", "   " ) );
		
		local func = function()
		
			if( not LocalPlayer():Alive() ) then return; end
		
			RunConsoleCommand( v.Cmd, "" );
		
		end
		
		EpContextPanel:AddLink( string.gsub( v.Text, " ", "   " ), "ActionMenuOption", w * .5 - tw * .5 + 6, ( k - 1 ) * 15 + 5, Color( 150, 0, 0, 255 ), func, Color( 255, 255, 255, 255 ) );
	
	end
	
	gui.EnableScreenClicker( true );

end

function CloseEpidemicContextMenu()

	if( IRONSIGHTS_DEV ) then
	
		DestroyIronSightsDev();
		return;
	
	end
	
	if( !EpContextPanel ) then
		
		return;
		
	end

	EpContextPanel:Remove();
	EpContextPanel = nil;
	
	HideMouse();

end

GModContext = false;

function GM:OnContextMenuOpen()
 
 	if( not LocalPlayer():Alive() ) then return; end
 	if( PlayerMenuPanel:IsVisible() ) then return; end
 	if( BlackScreenOn or OpeningScreen.HUDOverride ) then return; end
 	if( not hook.Call( "SpawnMenuOpen", GAMEMODE ) ) then return; end
    
    if( LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" ) then
    
	    if( g_ContextMenu ) then 

	    	g_ContextMenu:Open();
	    	GModContext = true;
	
	    end
	    
	else
	
		OpenEpidemicContextMenu();
		GModContext = false;
	
	end
       
end

function GM:OnContextMenuClose()

	if( GModContext ) then

		if( g_ContextMenu ) then 

			g_ContextMenu:Close();
	
		end
	
	else
	
		CloseEpidemicContextMenu();
	
	end   
	
end
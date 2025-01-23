
surface.CreateFont( "Digital-7", 48, 400, true, false, "RadioFreq" );

Radios = { }
RadioWindows = { }

function OpenRadioFreq( inv, x, y )

	local uniqueid = InventoryItems[inv][x][y].UniqueID;

	if( RadioWindows[uniqueid] ) then
	
		RadioWindows[uniqueid]:Remove();
		RadioWindows[uniqueid] = nil;
	
	end

	local mx, my = gui.MousePos();

	local pnl = CreateBPanel( "Set Frequency", mx, my, 331, 65 );

	local function raisefreq( f, d )
	
		Radios[uniqueid].DFreq = math.floor( Radios[uniqueid].DFreq + d );
		
		if( Radios[uniqueid].DFreq > 9 ) then
		
			f = f + 1;
			Radios[uniqueid].DFreq = 0;
		
		elseif( Radios[uniqueid].DFreq < 0 ) then
		
			f = f - 1;
			Radios[uniqueid].DFreq = 9;			
		
		end
		
		Radios[uniqueid].Freq = math.Clamp( math.floor( Radios[uniqueid].Freq + f ), 0, 999 );
	
		if( RadioMenu and RadioMenu:IsValid() and RadioMenu.Buttons and
			RadioMenu.Buttons[uniqueid] and RadioMenu.Buttons[uniqueid]:IsValid() ) then
			
			RadioMenu.Buttons[uniqueid]:SetText( Radios[uniqueid].Freq .. "." .. Radios[uniqueid].DFreq );
			
			if( SelectedRadioFreq == uniqueid ) then
			
				RunConsoleCommand( "eng_rf", Radios[uniqueid].Freq, Radios[uniqueid].DFreq );
			
			end
			
		end
	
	end

	local function lowerfreq( f, d )
	
		raisefreq( f * -1, d * -1 );
	
	end
	
	local but = pnl:AddButton( "<<", 10, 10 );
	but:SetSize( 40, 40 );
	
	but.MouseDownThink = function()
	
		lowerfreq( 100 * FrameTime(), 0 );
	
	end
	
	local but = pnl:AddButton( "<", 55, 10 );
	but:SetSize( 40, 40 );
	
	but.Action = function()
	
		lowerfreq( 0, 1 );
	
	end
	
	local but = pnl:AddButton( ">", 233, 10 );
	but:SetSize( 40, 40 );
	
	but.Action = function()
	
		raisefreq( 0, 1 );
	
	end
	
	local but = pnl:AddButton( ">>", 278, 10 );
	but:SetSize( 40, 40 );
	
	but.MouseDownThink = function()
	
		raisefreq( 100 * FrameTime(), 0 );
	
	end
	
	pnl.PaintHook = function()
	
		draw.RoundedBox( 2, 110, 10, 110, 45, Color( 117, 194, 107, 255 ) );
		draw.DrawText( Radios[uniqueid].Freq .. "." .. Radios[uniqueid].DFreq, "RadioFreq", 210, 10, Color( 0, 0, 0, 255 ), 2 );
	
	end
	
	RadioWindows[uniqueid] = pnl;

end

SelectedRadioFreq = 0;
HasSet0Radio = false;

function FillRadioChatMenu()

	if( RadioMenu.Buttons ) then
	
		for k, v in pairs( RadioMenu.Buttons ) do
		
			v:Remove();
		
		end
	
	end

	RadioMenu.Buttons = { }

	local count = 1;
	
	if( !HasSet0Radio ) then
		
		RunConsoleCommand( "eng_rf", 0, 0 );
		HasSet0Radio = true;
		
	end

	for k, v in pairs( Radios ) do
	
		RadioMenu.Buttons[k] = RadioMenu:AddButton( v.Freq .. "." .. v.DFreq, 5, 10 + ( count - 1 ) * 33 );
		
		local w, h = RadioMenu.Buttons[k]:GetSize();
		
		RadioMenu.Buttons[k]:SetSize( w + 5, h + 5 );
		
		RadioMenu.Buttons[k].Action = function()
		
			RadioMenu.Buttons[k].HighlightRed = true;
			RadioMenu.Buttons[k].AlwaysHighlight = true;
			
			SelectedRadioFreq = k;
			
			RunConsoleCommand( "eng_rf", v.Freq, v.DFreq );
			
			for n, m in pairs( RadioMenu.Buttons ) do
			
				if( n ~= k ) then
				
					m.HighlightRed = false;
					m.AlwaysHighlight = false;
				
				end
			
			end
		
		end
		
		if( SelectedRadioFreq == k ) then
			
			RadioMenu.Buttons[k].HighlightRed = true;
			RadioMenu.Buttons[k].AlwaysHighlight = true;
			
		end
		
		count = count + 1;
	
	end

end

function DestroyRadioChatMenu()

	if( RadioMenu and RadioMenu:IsValid() ) then

		RadioMenu:Remove();
		RadioMenu = nil;
	
	end

end

function CreateRadioChatMenu()

	if( RadioMenu ) then
	
		DestroyRadioChatMenu();
	
	end

	RadioMenu = CreateBPanel( nil, 410, ScrH() - 435, 60, 200 );
	RadioMenu.BodyColor = Color( 0, 0, 0, 100 );
	RadioMenu:EnableScrolling( true );
	
	FillRadioChatMenu();

end

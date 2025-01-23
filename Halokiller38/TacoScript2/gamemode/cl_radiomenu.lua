function PromptRadioMenu()

	if( RadioMenu ) then
	
		if( RadioMenu.Entry ) then
			RadioMenu.Entry:Remove();
		end	
		
		if( RadioMenu.TitleBar ) then
			RadioMenu.TitleBar:Remove()
		end
		
		RadioMenu:Remove(); 
		
	end
	
	RadioMenu = CreateBPanel( "Radio Frequency", 350, 300, 140, 50 );
	RadioMenu:SetBodyColor( Color( 30, 30, 30, 170 ) );
	RadioMenu:CanClose( true );
	RadioMenu:CanDrag( false );
	RadioMenu:MakePopup();
	
	local x, y = RadioMenu:GetPos();
	
	RadioMenu.Entry = vgui.Create( "DTextEntry", RadioMenu );
	RadioMenu.Entry:SetSize( 80, 20 );
	RadioMenu.Entry:SetPos( x + 10, y + 10 );
	RadioMenu.Entry:SetEditable( true );
	RadioMenu.Entry:MakePopup();
	
	RadioMenu.Entry.OnEnter = function()
	
		if( not tonumber( RadioMenu.Entry:GetValue() ) ) then
		
			CreateOkPanel( "Invalid Frequency", "Invalid frequency!" );
			return;
		
		end
	
		if( tonumber( RadioMenu.Entry:GetValue() ) < 0 or
			tonumber( RadioMenu.Entry:GetValue() ) > 999.9 ) then
		
			CreateOkPanel( "Invalid Frequency", "Frenquency has to be between 1 and 999.9" );
			return;		
		
		end
		
		RunConsoleCommand( "rp_changefrequency", RadioMenu.Entry:GetValue() );
		
		if( RadioMenu ) then
		
			if( RadioMenu.Entry ) then
				RadioMenu.Entry:Remove();
			end
			
			if( RadioMenu.TitleBar ) then
				RadioMenu.TitleBar:Remove();
			end
			
			RadioMenu:Remove();
			
		end
		
	end
	
	function RadioMenu:OnClose()
	
		if( RadioMenu.Entry ) then
			RadioMenu.Entry:Remove();
		end	
		
		if( RadioMenu.TitleBar ) then
			RadioMenu.TitleBar:Remove()
		end

	end

end
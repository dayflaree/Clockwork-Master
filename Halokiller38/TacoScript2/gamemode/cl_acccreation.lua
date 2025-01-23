if( AccountMenu ) then

	if( AccountMenu.TitleBar ) then

		AccountMenu.TitleBar:Remove();
		
	end
	
	AccountMenu:Remove();

end

AccountMenu = nil;

function msgCreateAccountMenu()
	
	AccountMenu = CreateBPanel( "Create Account", ScrW() / 2 - 152, math.Clamp( ScrH() / 2 - 210, ScrH() * .1 + 70, 9999 ), 300, 200 );
	AccountMenu:CanClose( false );
	AccountMenu:CanDrag( false );
	AccountMenu:SetBodyColor( Color( 40, 40, 40, 220 ) );
	
	AccountMenu:AddLabel( "To continue, you must create an account\nEnter a unique name in the box below..", "NewChatFont", 12, 9, Color( 255, 255, 255, 255 ) );
	
	local x, y = AccountMenu:GetPos();
	
	AccountMenu.SQLNameEntry = vgui.Create( "DTextEntry", AccountMenu );
	AccountMenu.SQLNameEntry:SetPos( x + 80, y + 80 );
	AccountMenu.SQLNameEntry:SetSize( 130, 18 );
	AccountMenu.SQLNameEntry:MakePopup();
	
	AccountMenu.SQLNameEntryButton = AccountMenu:AddButton( "Register", 115, 103 );

	AccountMenu.SQLNameEntryButton.Action = function()
	
		if( string.len( AccountMenu.SQLNameEntry:GetValue() ) < 5 or
			string.len( AccountMenu.SQLNameEntry:GetValue() ) > 16 ) then
		
			CreateOkPanel( "Invalid name length", "Your Username needs to be between 5 and 16 characters" );
			return;		
		
		end
		
		if( string.find( "'", AccountMenu.SQLNameEntry:GetValue() ) ) then
		
			return;
		
		end
		
		RunConsoleCommand( "eng_createaccount", AccountMenu.SQLNameEntry:GetValue() );
		
	end
	
	ApplyMaxCharacters( AccountMenu.SQLNameEntry, 16 );
	
	gui.EnableScreenClicker( true );

end
usermessage.Hook( "HandleAccountCreation", msgCreateAccountMenu );

function RemoveAccountMenu()
	
	if( AccountMenu ) then
	
		if( AccountMenu.TitleBar ) then
	
			AccountMenu.TitleBar:Remove();
			
		end
		
		AccountMenu:Remove();
		AccountMenu = nil;

	end

end
usermessage.Hook( "RAM", RemoveAccountMenu );

function DuplicateAccount()

	CreateOkPanel( "Invalid name!", "Somebody else already has that username!" );
	return;

end
usermessage.Hook( "DAC", DuplicateAccount );

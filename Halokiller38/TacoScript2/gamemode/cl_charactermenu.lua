if( CharacterMenu ) then

	if( CharacterMenu.CharChooseMenu ) then
	
		CharacterMenu.CharChooseMenu:Remove();
	
	end
	
	CharacterMenu:Remove();

end

CharacterMenu = nil;

CharacterList = { }
local ChosenCharacterModel = "";

function CreateCharacterMenu()

	DontDrawDisplay = true;

	local FreeStatPoints = 50;
	local MaxFreeStats = FreeStatPoints;
	local ChosenCharacterName = "";
	
	CharacterMenu = CreateBPanel( nil, ScrW() / 2 - 400, math.Clamp( ScrH() / 2 - 210, ScrH() * .1 + 70, 9999 ), 800, 420 );
	CharacterMenu:CanClose( false );
	CharacterMenu:CanDrag( false );
	CharacterMenu:SetBodyColor( Color( 40, 40, 40, 220 ) );
	
	local x, y = CharacterMenu:GetPos();
	
	CharacterMenu.PaintHook = function()
	
		local strperc = ClientVars["Strength"] / 100;
		local spdperc = ClientVars["Speed"] / 100;
		local endperc = ClientVars["Endurance"] / 100;
		local aimperc = ClientVars["Aim"] / 100;
		local freeperc = FreeStatPoints / MaxFreeStats;
	
		draw.DrawText( "Strength - " .. ClientVars["Strength"], "SmallChatFont", 260, 135, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 255, 150, 100, 20, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 256, 151, 98 * strperc, 18, Color( 0, 128, 0, 255 ) );
		draw.RoundedBox( 2, 256, 151, 98 * strperc, 6, Color( 255, 255, 255, 20 ) );
		draw.DrawText( "Speed - " .. ClientVars["Speed"], "SmallChatFont", 260, 175, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 255, 190, 100, 20, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 256, 191, 98 * spdperc, 18, Color( 0, 128, 0, 255 ) );
		draw.RoundedBox( 2, 256, 191, 98 * spdperc, 6, Color( 255, 255, 255, 20 ) );
		draw.DrawText( "Endurance - " .. ClientVars["Endurance"], "SmallChatFont", 260, 215, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 255, 230, 100, 20, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 256, 231, 98 * endperc, 18, Color( 0, 128, 0, 255 ) );
		draw.RoundedBox( 2, 256, 231, 98 * endperc, 6, Color( 255, 255, 255, 20 ) );
		draw.DrawText( "Aim - " .. ClientVars["Aim"], "SmallChatFont", 260, 255, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 255, 270, 100, 20, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 256, 271, 98 * aimperc, 18, Color( 0, 128, 0, 255 ) );
		draw.RoundedBox( 2, 256, 271, 98 * aimperc, 6, Color( 255, 255, 255, 20 ) );
		draw.DrawText( "Free Stat Points - " .. FreeStatPoints, "SmallChatFont", 260, 295, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 255, 310, 100, 20, Color( 0, 0, 0, 255 ) );
		
		if( freeperc > 0 ) then
		
			draw.RoundedBox( 2, 256, 311, 98 * freeperc, 18, Color( 0, 0, 128, 255 ) );
			draw.RoundedBox( 2, 256, 311, 98 * freeperc, 6, Color( 255, 255, 255, 20 ) );

		end

	end
	
	local function Add( stat )
	
		if( FreeStatPoints > 0 ) then
	
			ClientVars[stat] = ClientVars[stat] + 1;
			FreeStatPoints = FreeStatPoints - 1;
			
		end
	
	end
	
	local function Subtract( stat )
	
		if( ClientVars[stat] > 10 ) then
	
			ClientVars[stat] = ClientVars[stat] - 1;
			FreeStatPoints = FreeStatPoints + 1;
			
		end		
	
	end
	
	CharacterMenu:AddButton( "-", 230, 150, function() Subtract( "Strength" ) end );
	CharacterMenu:AddButton( "-", 230, 190, function() Subtract( "Speed" ) end );
	CharacterMenu:AddButton( "-", 230, 230, function() Subtract( "Endurance" ) end );
	CharacterMenu:AddButton( "-", 230, 270, function() Subtract( "Aim" ) end )
	
	CharacterMenu:AddButton( "+", 364, 150, function() Add( "Strength" ) end );
	CharacterMenu:AddButton( "+", 364, 190, function() Add( "Speed" ) end );
	CharacterMenu:AddButton( "+", 364, 230, function() Add( "Endurance" ) end );
	CharacterMenu:AddButton( "+", 364, 270, function() Add( "Aim" ) end );
	
	CharacterMenu:AddLabel( "Create New Character", "BigTargetID", 5, 20, Color( 255, 255, 255, 255 ) );
	CharacterMenu:AddLabel( "Character Select", "BigTargetID", 600, 2, Color( 255, 255, 255, 255 ) );
	CharacterMenu:AddLabel( "Full Name", "TargetID", 8, 50, Color( 255, 255, 255, 255 ) );
	CharacterMenu:AddLabel( "Age", "TargetID", 8, 70, Color( 255, 255, 255, 255 ) );
	CharacterMenu:AddLabel( "Model", "TargetID", 8, 90, Color( 255, 255, 255, 255 ) );
	
	CharacterMenu:AddLabel( "Not creating a character with a first and last name will get you banned.", "ChatFont", 5, 5, Color( 237, 0, 0, 255 ) );
	
	CharacterMenu.NameEntry = vgui.Create( "DTextEntry", CharacterMenu );
	CharacterMenu.NameEntry:SetPos( x + 90, y + 53 );
	CharacterMenu.NameEntry:SetSize( 200, 15 );
	CharacterMenu.NameEntry:MakePopup();
	
	ApplyMaxCharacters( CharacterMenu.NameEntry, 38 );
	
	CharacterMenu.AgeEntry = vgui.Create( "DTextEntry", CharacterMenu );
	CharacterMenu.AgeEntry:SetPos( x + 90, y + 74 );
	CharacterMenu.AgeEntry:SetSize( 20, 15 );
	CharacterMenu.AgeEntry:MakePopup();
	
	ApplyMaxCharacters( CharacterMenu.AgeEntry, 2 );
	
	CharacterMenu.ModelSelectPanel = CreateBPanel( nil, 5, 105, 216, 256 );
	CharacterMenu.ModelSelectPanel:SetParent( CharacterMenu );
	CharacterMenu.ModelSelectPanel:SetBodyColor( Color( 30, 30, 30, 255 ) );
	CharacterMenu.ModelSelectPanel:CanClose( false );
	CharacterMenu.ModelSelectPanel:CanDrag( false );
	CharacterMenu.ModelSelectPanel:CanSeeTitle( false );
	CharacterMenu.ModelSelectPanel:EnableScrolling( true );
	
	CharacterMenu.ModelViewPanel = CreateBPanel( nil, 400, 10, 190, 350 );
	CharacterMenu.ModelViewPanel:SetParent( CharacterMenu );
	CharacterMenu.ModelViewPanel:CanClose( false );
	CharacterMenu.ModelViewPanel:CanDrag( false );
	CharacterMenu.ModelViewPanel:CanSeeTitle( false );
	CharacterMenu.ModelViewPanel:EnableScrolling( true );
	CharacterMenu.ModelViewPanel:SetBodyColor( Color( 30, 30, 30, 255 ) );

	local CharacterLinks = { }
	local SortedCharacters = { }
	local LastSelectedLink;
	local cury = 5;
	
	local function AddLink( name, x, y, func )
	
		local link = vgui.Create( "BLink", CharacterMenu.CharChooseMenu );
		link:SetPos( x, y );
		link:SetFont( "NewChatFont" );
		link:SetText( name );
		link:SizeToContents();
		link.HighlightColor = Color( 34, 182, 255, 255 );
		link.NormalColor = Color( 255, 255, 255, 255 );
		link.Action = func;
	
		table.insert( CharacterLinks, link );
	
	end
	
	CharacterMenu.CharChooseMenu = CreateBPanel( nil, 600, 10, 190, 350 );
	CharacterMenu.CharChooseMenu:SetParent( CharacterMenu );
	CharacterMenu.CharChooseMenu:CanClose( false );
	CharacterMenu.CharChooseMenu:CanDrag( false );
	CharacterMenu.CharChooseMenu:SetBodyColor( Color( 30, 30, 30, 255 ) );
	
	CharacterMenu.CharChooseMenu.Think = function()
	
		for k, v in pairs( CharacterList ) do
		
			if( not SortedCharacters[v.Name] ) then
			
				AddLink( v.Name, 6, cury, function( self )
				
					if( LastLinkSelected ) then
						LastLinkSelected:SetColor( self.NormalColor );	
					end

					ChosenCharacterName = v.Name;
					self:SetColor( self.HighlightColor );
					LastLinkSelected = self;
					
					SetPlayerViewModel( v.Model );

				end );
				
				cury = cury + 18;
				
				SortedCharacters[v.Name] = { }
				
			end
			
		end
		
	end
	
	SetPlayerViewModel = function( model )
	
		ChosenCharacterModel = model;
	
		if( not CharacterMenu.ModelViewPanel.Model ) then
		
			CharacterMenu.ModelViewPanel.Model = vgui.Create( "DModelPanel", CharacterMenu.ModelViewPanel );
			CharacterMenu.ModelViewPanel.Model:SetPos( -70, 0 );
			CharacterMenu.ModelViewPanel.Model:SetSize( 350, 350 );
			CharacterMenu.ModelViewPanel.Model:SetModel( model );
			
			CharacterMenu.ModelViewPanel.Model.LayoutEntity = function( self )
			
			self:RunAnimation();
			self:SetAnimSpeed( 0.8 );
			
		 	end
		 	
			CharacterMenu.ModelViewPanel.Model:SetFOV( 100 );
			CharacterMenu.ModelViewPanel.Model:SetLookAt( Vector( 0, 0, 50 ) );
	 		CharacterMenu.ModelViewPanel.Model:SetCamPos( Vector( 30, -10, 55 ) );

		
		else
		
			CharacterMenu.ModelViewPanel.Model:SetModel( model );
		
		end
	
	end
	
	CharacterMenu.ModelSelectPanel.Models = { };
	
	local modelx = 0;
	local modely = 0;
	
	for k, v in pairs( TS.SelectablePlayerModels ) do
	
		CharacterMenu.ModelSelectPanel.Models[k] = vgui.Create( "SpawnIcon", CharacterMenu.ModelSelectPanel );
		CharacterMenu.ModelSelectPanel.Models[k]:SetModel( v );
		CharacterMenu.ModelSelectPanel.Models[k]:SetPos( modelx, modely );
		CharacterMenu.ModelSelectPanel.Models[k]:SetSize( 64, 64 );

		CharacterMenu.ModelSelectPanel.Models[k].LayoutEntity = function()
		
	 	end
	 	
	 	CharacterMenu.ModelSelectPanel.Models[k].DoClick = function()
	 	
	 		SetPlayerViewModel( v );
	 	
	 	end
	 	
	 	CharacterMenu.ModelSelectPanel:AddObject( CharacterMenu.ModelSelectPanel.Models[k] );
	 	
	 	modelx = modelx + 64;
	 	
	 	if( modelx >= 192 ) then
	 	
	 		modely = modely + 64;
	 		modelx = 0;
	 	
	 	end
	 	
	end
	
	CharacterMenu.CreateCharacterButton = CharacterMenu:AddButton( "Create Character", 5, 385 );
	
	CharacterMenu.CreateCharacterButton.Action = function()
	
		if( string.len( CharacterMenu.NameEntry:GetValue() ) < 3 or
			string.len( CharacterMenu.NameEntry:GetValue() ) > 30 ) then
		
			CreateOkPanel( "Invalid name", "Your name needs to be between 3 and 30 characters" );
			return;		
		
		end
	
		if( string.gsub( CharacterMenu.NameEntry:GetValue(), " ", "" ) == "" ) then
		
			CreateOkPanel( "Invalid name", "Your nme cannot be blank" );
			return;		
		
		end
	
		if( not tonumber( CharacterMenu.AgeEntry:GetValue() ) ) then
		
			CreateOkPanel( "Invalid numbers", "Invalid age" );
			return;
		
		end
		
		if( tonumber( CharacterMenu.AgeEntry:GetValue() ) < 16 or
			tonumber( CharacterMenu.AgeEntry:GetValue() ) > 80 ) then
			
			CreateOkPanel( "Invalid numbers", "Age must be between 18 and 80" );
			return;			
			
		end
	
		if( ChosenCharacterModel == "" ) then
		
			CreateOkPanel( "Invalid model", "Choose a model" );
			return;
		
		end
		
		if( not table.HasValue( TS.SelectablePlayerModels, ChosenCharacterModel ) ) then
		
			CreateOkPanel( "Invalid model", "HOW'D YOU GET THAT MODEL YOU FUCKING FAGGOT" );
			return;			
		
		end
	
		RunConsoleCommand( "eng_ccsetname", CharacterMenu.NameEntry:GetValue() );
		RunConsoleCommand( "eng_ccsetage", CharacterMenu.AgeEntry:GetValue() );
		RunConsoleCommand( "eng_ccsetmodel", ChosenCharacterModel );
		RunConsoleCommand( "eng_ccsetstats", ClientVars["Strength"], ClientVars["Endurance"], ClientVars["Speed"], ClientVars["Aim"] );
		RunConsoleCommand( "eng_createcharacter", "" );
		
		DontDrawDisplay = false;
		
		LastLinkSelected = nil;
		CharacterList = { }
		
	end
	
	CharacterMenu.SelectCharacterButton = CharacterMenu:AddButton( "Select Character", 600, 385 );
	
	CharacterMenu.SelectCharacterButton.Action = function()
	
		if( ChosenCharacterName == "" ) then
		
			CreateOkPanel( "Error", "You must select a character first!" );
			return;
		
		end
		
		RunConsoleCommand( "eng_selectchar", ChosenCharacterName );
		
		DontDrawDisplay = false;
		
		LastLinkSelected = nil;
		CharacterList = { }
	
	end
	
	gui.EnableScreenClicker( true );
	
end
usermessage.Hook( "PCM", CreateCharacterMenu );

function msgRecieveCharacter( msg )

	local name = msg:ReadString();
	local model = msg:ReadString();
	
	table.insert( CharacterList, { Name = name, Model = model } );
	
end
usermessage.Hook( "SMC", msgRecieveCharacter );

function RemoveCharacterMenu( msg )
	
	if( CharacterMenu ) then
		
		CharacterMenu:Remove();
		
	end

end
usermessage.Hook( "RCM", RemoveCharacterMenu );

function RemoveCharacterSelection( msg )
	
	if( CharacterMenu.CharChooseMenu ) then
		
		CharacterMenu.CharChooseMenu:Remove();
		
	end

end
usermessage.Hook( "RCS", RemoveCharacterSelection );

function MaxCharacters( msg )

	CreateOkPanel( "Error!", "You cannot create anymore characters! You have reached the max!" );
	return;
	
end
usermessage.Hook( "MC", MaxCharacters );

function DuplicateCharacter( msg )

	CreateOkPanel( "Invalid name!", "You already have a character with that name!" );
	return;
	
end
usermessage.Hook( "DC", DuplicateCharacter );
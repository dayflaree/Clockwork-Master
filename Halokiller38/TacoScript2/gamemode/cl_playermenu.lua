Tokens = 0;
CID = 0;

PlayerMenuVisible = false;

PlayerMenuIntro = 0;

function event.PlayerMenuOff()

	if( PlayerMenuVisible ) then
	
		TogglePlayerMenu();
	
	end

end

function TogglePlayerMenu()
	
	PlayerMenuVisible = !PlayerMenuVisible;

	StorageItemID = nil;
	
	ShowCharInfo = !ShowCharInfo;

	for k, v in pairs( PlayerMenuLinks ) do

		v:SetVisible( PlayerMenuVisible and (not v.VisibleCallback or v:VisibleCallback()) );
		
		local x, y = v:GetPos();
		
		v:SetPos( -1000, y );

	end
	
	if( PlayerInfoPanel and PlayerInfoPanel:IsValid() ) then
	
		if( PlayerInfoPanel.TitleBar and PlayerInfoPanel.TitleBar:IsValid() ) then
			PlayerInfoPanel.TitleBar:SetVisible( PlayerMenuVisible );
		end
		
		PlayerInfoPanel:SetVisible( PlayerMenuVisible );
	
	end
	
	if( PlayerMenuVisible ) then
	
		gui.EnableScreenClicker( true );
		
		InventoryMenu:SetVisible( true );
		InventoryMenu.TitleBar:SetVisible( true );
		
		PlayerMenuIntro = 0;
		
		RemoveItemButtons();
		
	else
	
		if( StorageMenu ) then
			StorageMenu:Remove();
			StorageMenu = nil;
		end
		
		if( RadioFrame ) then
			RadioFrame:Remove();
		end
		
		InventoryMenu:SetVisible( false );
		InventoryMenu.TitleBar:SetVisible( false );
		
		ResetItemData();
		
		HideMouse();
	
	end
	
end
usermessage.Hook( "TPM", TogglePlayerMenu );

surface.CreateFont( "TargetID", 22, 800, true, false, "IDHeader" );
surface.CreateFont( "TargetID", 18, 800, true, false, "IDHeader2" );
surface.CreateFont( "BudgetLabel", 16, 200, true, false, "IDInfo" );
surface.CreateFont( "BudgetLabel", 16, 800, true, false, "IDInfo2" );
surface.CreateFont( "BudgetLabel", 9, 100, true, false, "IDInfo3" );

function DrawPlayerMenu()

	for k, v in pairs( PlayerMenuLinks ) do
	
		local x, y = v:GetPos();
	
		v:SetPos( ( ScrW() * -.15 - 2 ) + ( ( ScrW() * .15 + 8 ) * ( PlayerMenuIntro / 100 ) ), y );
	
	end

	local sw = 125;
	
	HealthAlpha = 255;
	SprintAlpha = 255;
	
	ShowCharInfo = false;
	
	local tokentext = "";
	
	if Tokens == 1 then
		tokentext = " token";
	else
		tokentext = " tokens";
	end
	
	local hudtype = CreateClientConVar( "rp_cl_ts1hud", "0", true, false );
	
	local CharInfo = Tokens .. tokentext .. "\nCID: " .. CID .. "\n" ..  ClientVars["Title"] .. "\n" .. ClientVars["Title2"];
	
	draw.DrawText( CharInfo, "NewChatFont", ( ScrW() * -.15 - 2 ) + ( ( ScrW() * .15 + 8 ) * ( PlayerMenuIntro / 100 ) ), ScrH() - 180, Color( 255, 255, 255, 255 ) );

	for n = 1, #TS.PlayerStats do
	
		local perc = ClientVars[TS.PlayerStats[n]] / 100;
	
		draw.RoundedBox( 2, ( ScrW() * -.15 - 2 ) + ( ( ScrW() * .15 + 8 ) * ( PlayerMenuIntro / 100 ) ), ScrH() - sw + ( 20 * n ), ( ScrW() * .15 - 2 ), 14, Color( 0, 0, 0, 255 ) );
		local w = ( ScrW() * .15 - 2 );
		
		if( perc > 0 ) then
			draw.RoundedBox( 2, ( ScrW() * -.15 - 2 ) + ( ( ScrW() * .15 + 8 ) * ( PlayerMenuIntro / 100 ) ) + 2, ScrH() - sw + ( 20 * n ) + 2, ( ScrW() * .15 - 6 ) * perc, 10, Color( 39, 64, 139, 255 ) );
			draw.RoundedBox( 2, ( ScrW() * -.15 - 2 ) + ( ( ScrW() * .15 + 8 ) * ( PlayerMenuIntro / 100 ) ) + 2, ScrH() - sw + ( 20 * n ) + 2, ( ScrW() * .15 - 6 ) * perc, 4, Color( 58, 95, 205, 255 ) );
		end
		
		draw.DrawText( TS.PlayerStats[n] .. " - " .. ClientVars[TS.PlayerStats[n]], "SmallChatFont", ( ScrW() * -.15 - 2 ) + ( ( ScrW() * .15 + 8 ) * ( PlayerMenuIntro / 100 ) ) + 2, ScrH() - sw + ( 20 * n ) + 2, Color( 255, 255, 255, 255 ) );	
		
	end

end

function PlayerMenuThink()

	if( PlayerMenuIntro < 100 ) then
		
		PlayerMenuIntro = math.Clamp( PlayerMenuIntro + 500 * FrameTime(), 0, 100 );
	
	end

end

if( PlayerMenuLinks ) then

	for k, v in pairs( PlayerMenuLinks ) do
		v:Remove();
	end
	
end

PlayerMenuLinks = { }

function CreatePlayerMenu()

	local function AddLink( name, y, func, viscallback )
	
		local link = vgui.Create( "BLink" );
		link:SetPos( ( ScrW() * -.15 - 2 ) + ( ( ScrW() * .15 + 8 ) * ( PlayerMenuIntro / 100 ) ), y );
		link:SetFont( "NewChatFont" );
		link:SetText( name );
		link:SizeToContents();
		link.HighlightColor = Color( 34, 182, 255, 255 );
		link.Action = func;
		link.VisibleCallback = viscallback;
		
		table.insert( PlayerMenuLinks, link );
	
	end
	
	AddLink( "Character Menu", ScrH() - 235, function() RunConsoleCommand( "eng_charmenu", "" ); end );
	AddLink( "Help", ScrH() - 220, function() RunConsoleCommand( "gm_showhelp", "" ); end );
	AddLink( "Blackmarket", ScrH() - 205, function() RunConsoleCommand( "rp_spawning", ""); end, function() return LocalPlayer().CanAccessBM; end );
end

CreatePlayerMenu();

function CreateAddDoorOwnerMenu( msg )
	
	AddDoorOwnerMenu = CreateBPanel( "Give out a spare set of keys.", ( ScrW() * .5 ) - 100, ( ScrH() * .5 ) - 25, 200, 50 );
	AddDoorOwnerMenu:CanClose( true );
	AddDoorOwnerMenu:CanDrag( false );
	AddDoorOwnerMenu:SetBodyColor( Color( 40, 40, 40, 220 ) );
	
	AddDoorOwnerMenu:AddLabel( "Recipitant:", "NewChatFont", 13, 8, Color( 255, 255, 255, 255 ) );
	
	local x, y = AddDoorOwnerMenu:GetPos();
	
	AddDoorOwnerMenu.NameEntry = vgui.Create( "DTextEntry", AddDoorOwnerMenu );
	AddDoorOwnerMenu.NameEntry:SetPos( x + 80, y + 8 );
	AddDoorOwnerMenu.NameEntry:SetSize( 100, 15 );
	AddDoorOwnerMenu.NameEntry:MakePopup();
	
	ApplyMaxCharacters( AddDoorOwnerMenu.NameEntry, 20 );
	
	AddDoorOwnerMenu.SetOwner = AddDoorOwnerMenu:AddButton( "Give Keys", 60, 25);
	
	AddDoorOwnerMenu.SetOwner.Action = function()
		
		RunConsoleCommand( "eng_ado", AddDoorOwnerMenu.NameEntry:GetValue() );
	
	end
	
	gui.EnableScreenClicker( true );

end
usermessage.Hook( "PADO", CreateAddDoorOwnerMenu );

function RemoveAddDoorOwnerMenu( msg )
	
	if( AddDoorOwnerMenu and AddDoorOwnerMenu.TitleBar ) then
	
		AddDoorOwnerMenu.TitleBar:Remove();
		AddDoorOwnerMenu:Remove();

	end

end
usermessage.Hook( "RADO", RemoveAddDoorOwnerMenu );

function CreateNameMenu( msg )

	local propertyname = msg:ReadString();
	local doorname = msg:ReadString();
	
	NameMenu = CreateBPanel( "Set this door/property name", ( ScrW() * .5 ) - 125, ( ScrH() * .5 ) - 40, 250, 80 );
	NameMenu:CanClose( true );
	NameMenu:CanDrag( false );
	NameMenu:SetBodyColor( Color( 40, 40, 40, 220 ) );
	
	NameMenu:AddLabel( "Door Name:", "NewChatFont", 5, 8, Color( 255, 255, 255, 255 ) );
	NameMenu:AddLabel( "Property Name:", "NewChatFont", 5, 25, Color( 255, 255, 255, 255 ) );
	
	local x, y = NameMenu:GetPos();

	NameMenu.DoorNameEntry = vgui.Create( "DTextEntry", NameMenu );
	NameMenu.DoorNameEntry:SetPos( x + 80, y + 8 );
	NameMenu.DoorNameEntry:SetSize( 163, 15 );
	NameMenu.DoorNameEntry:SetText( doorname );
	NameMenu.DoorNameEntry:MakePopup();
	
	ApplyMaxCharacters( NameMenu.DoorNameEntry, 20 );
	
	NameMenu.PropNameEntry = vgui.Create( "DTextEntry", NameMenu );
	NameMenu.PropNameEntry:SetPos( x + 103, y + 25 );
	NameMenu.PropNameEntry:SetSize( 140, 15 );
	NameMenu.PropNameEntry:SetText( propertyname );
	NameMenu.PropNameEntry:MakePopup();
	
	
	ApplyMaxCharacters( NameMenu.PropNameEntry, 20 );
	
	NameMenu.SetNames = NameMenu:AddButton( "Name Property", 75, 50);
	
	NameMenu.SetNames.Action = function()
	
		if( string.gsub( NameMenu.DoorNameEntry:GetValue(), " ", "" ) == "" ) then
		
			CreateOkPanel( "Invalid door name.", "Door name cannot be blank" );
			return;		
		
		end
		
		--[[if( string.gsub( NameMenu.PropNameEntry:GetValue(), " ", "" ) == "" ) then
		
			CreateOkPanel( "Invalid property name.", "Property name is blank, queer." );
			return;		
		
		end]]--
		
		RunConsoleCommand( "eng_setdoorname", NameMenu.DoorNameEntry:GetValue() );
		RunConsoleCommand( "eng_setpropertyname", NameMenu.PropNameEntry:GetValue() );
	
	end
	
	gui.EnableScreenClicker( true );

end
usermessage.Hook( "PNM", CreateNameMenu );

function RemoveNameMenu( msg )
	
	if( NameMenu and NameMenu.TitleBar ) then
	
		NameMenu.TitleBar:Remove();
		NameMenu:Remove();

	end

end
usermessage.Hook( "RNM", RemoveNameMenu );

if( SpawnFrameMain ) then

	if( SpawnFrameBack.TitleBar ) then
	
		SpawnFrameBack.TitleBar:Remove();
	
	end
	
	SpawnFrameBack:Remove();
	
end

SpawnFrameBack = nil;

SelectedMenu = 1;

function CreateSpawnMenu( msg )

	if( not LocalPlayer():Alive() ) then return; end

	if( SpawnFrameBack and SpawnFrameBack:IsVisible() ) then
	
		SpawnFrameBack:Remove();
		HideMouse();
		return;
	
	end
	
	local HasFreeSpawn = msg:ReadBool();

	if( PlayerMenuVisible ) then
		TogglePlayerMenu();
	end

	SpawnFrameBack = CreateBPanel( "Player Spawn Menu", ScrW()/2-500, ScrH()/2-450, 500, 450 );
	SpawnFrameBack:CanClose( true );
	SpawnFrameBack:CanDrag( true );
	SpawnFrameBack:SetBodyColor( Color( 20, 20, 20, 100 ) );
	
	SpawnFrameNav = CreateBPanel( nil, 10, 0, 480, 40 );
	SpawnFrameNav:SetParent( SpawnFrameBack );
	SpawnFrameNav:CanClose( false );
	SpawnFrameNav:CanDrag( false );
	SpawnFrameNav:SetBodyColor( Color( 30, 30, 30, 170 ) );
	
	SpawnFrameItem = CreateBPanel( nil, 10, 240, 480, 150 );
	SpawnFrameItem:SetParent( SpawnFrameBack );
	SpawnFrameItem:CanClose( false );
	SpawnFrameItem:CanDrag( false );
	SpawnFrameItem:SetBodyColor( Color( 30, 30, 30, 170 ) );
	
	local function CreateSpawnMenuPanel()
	
		if( SpawnMenu ) then
			SpawnMenu:Remove();
		end
		
		SpawnMenu = CreateBPanel( nil, 10, 50, 480, 180 );
		SpawnMenu:SetParent( SpawnFrameBack );
		SpawnMenu:SetBodyColor( Color( 0, 0, 0, 170 ) );
		SpawnMenu:EnableScrolling( true );
		
	end
	
	SpawnFrameNav.Links = { }
	
	for n = 1, #SpawnMenus do
		
		SpawnFrameNav.Links[n] = SpawnFrameNav:AddLink( SpawnMenus[n].Name, "NewChatFont", 10 + ( n - 1 ) * 100, 10, Color( 255, 255, 255, 200 ), function() CreateSpawnMenuPanel(); SpawnFrameNav.Links[SelectedMenu].NormalColor = Color( 255, 255, 255, 200 ); SpawnFrameNav.Links[n].NormalColor = Color( 80, 80, 255, 200 ); SelectedMenu = n; SpawnMenus[n].Func(); end );
		SpawnFrameNav.Links[n].HighlightColor = Color( 80, 80, 255, 255 );
		
		if( !HasFreeSpawn and SpawnMenus[n].Name == "Basic Items" ) then
		
			break;
		
		end
		
	end
	
	SpawnFrameNav.Links[1].Action();
	
	gui.EnableScreenClicker( true );
	
	SpawnFrameBack.OnClose = function()
	
		HideMouse();
	
	end
	
end
usermessage.Hook( "PSM", CreateSpawnMenu );

function ShowItemInformation( item, isweapon )

	if( SpawnFrameItem.Model ) then
		SpawnFrameItem.Model:Remove();
	end
	
	SpawnFrameItem.Model = vgui.Create( "DModelPanel", SpawnFrameItem );
	SpawnFrameItem.Model:SetPos( 10, 10 );

	if( isweapon ) then
	
		SpawnFrameItem.Model:SetModel( item.WorldModel );
		SpawnFrameItem.Model:SetSize( math.Clamp( item.ItemWidth * 50 * 2, 0, SpawnFrameItem:GetWide() ), math.Clamp( item.ItemHeight * 50 * 2, 0, SpawnFrameItem:GetTall() ) );
		SpawnFrameItem.Model:SetCamPos( item.IconCamPos );
		SpawnFrameItem.Model:SetLookAt( item.IconLookAt );
		SpawnFrameItem.Model:SetFOV( item.IconFOV );
		
		SpawnFrameItem.Model.DescText = FormatLine( item.TS2Desc .. "\n\nPrice: " .. item.Price, "NewChatFont",  SpawnFrameItem:GetWide() - math.Clamp( item.ItemWidth * 50 * 2, 15, SpawnFrameItem:GetWide() ) );
		
	else
	
		SpawnFrameItem.Model:SetModel( item.Model );
		SpawnFrameItem.Model:SetSize( math.Clamp( item.Width * 50 * 2, 0, SpawnFrameItem:GetWide() ), math.Clamp( item.Height * 50 * 2, 0, SpawnFrameItem:GetTall() ) );
		SpawnFrameItem.Model:SetCamPos( item.CamPos );
		SpawnFrameItem.Model:SetLookAt( item.LookAt );
		SpawnFrameItem.Model:SetFOV( item.FOV );
		
		SpawnFrameItem.Model.DescText = FormatLine( item.Desc .. "\n\nPrice: " .. item.Price, "NewChatFont",  SpawnFrameItem:GetWide() - math.Clamp( item.Width * 50 * 2, 15, SpawnFrameItem:GetWide() ) );
		
	end

	SpawnFrameItem.Model.LayoutEntity = function( self ) end
	
	SpawnFrameItem.PaintHook = function()
	
		draw.DrawText( item.Name or item.PrintName, "NewChatFont", SpawnFrameItem:GetWide() - 5, 10, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( SpawnFrameItem.Model.DescText or "", "NewChatFont", SpawnFrameItem:GetWide() - 2, 24, Color( 255, 255, 255, 255 ), 2 );
		
	end
	
	SpawnFrameItem.Button = SpawnFrameItem:AddButton( "Spawn", 420, 120 );
	
	local SpawnDelay = 0;
	
	SpawnFrameItem.Button.Action = function()
	
		if( CurTime() - SpawnDelay < 1.5 ) then
			return;
		end
		
		RunConsoleCommand( "rp_spawnitem", item.ID or item.ClassName );
		
		SpawnDelay = CurTime();
	
	end

end

function SMBasicItems()

	local itemx = 10;
	local itemy = 10;
	
	SpawnMenu.ItemIcons = { }

	for k, v in pairs( TS.SpawnableItems ) do

		SpawnMenu.ItemIcons[k] = vgui.Create( "SpawnIcon", SpawnMenu );
		SpawnMenu.ItemIcons[k]:SetModel( v.Model );
		SpawnMenu.ItemIcons[k]:SetPos( itemx, itemy );
		SpawnMenu.ItemIcons[k]:SetSize( 64, 64 );
		
		SpawnMenu:AddObject( SpawnMenu.ItemIcons[k] );

		itemx = itemx + 64;

		if( itemx >= 432 ) then
	 
			itemy = itemy + 64;
			itemx = 10;
	 	
		end
		
		SpawnMenu.ItemIcons[k].DoClick = function()
			
			ShowItemInformation( v, false );
	
		end
		
	end
	
end

function SMWeaponry()

	local itemx = 10;
	local itemy = 10;
	
	SpawnMenu.WeaponsIcons = { }

	for k, v in pairs( weapons.GetList() ) do
	
		if( string.find( v.ClassName, "ts2_" ) ) then
		
			if( LocalPlayer():IsAddingGoodWep( v.ClassName ) ) then
		
				SpawnMenu.WeaponsIcons[k] = vgui.Create( "SpawnIcon", SpawnMenu );
				SpawnMenu.WeaponsIcons[k]:SetModel( v.WorldModel );
				SpawnMenu.WeaponsIcons[k]:SetPos( itemx, itemy );
				SpawnMenu.WeaponsIcons[k]:SetSize( 64, 64 );
		
				SpawnMenu:AddObject( SpawnMenu.WeaponsIcons[k] );
		
				itemx = itemx + 64;

				if( itemx >= 432 ) then
	 
					itemy = itemy + 64;
					itemx = 10;
	 	
				end
		
				SpawnMenu.WeaponsIcons[k].DoClick = function()
				
					ShowItemInformation( v, true );
			
				end
			
			end
			
		end
		
	end
	
end

SpawnMenus = {

	{ Name = "Basic Items", Func = SMBasicItems },
	{ Name = "Weaponry", Func = SMWeaponry },

}
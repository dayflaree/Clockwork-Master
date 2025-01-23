
if( InventoryMenu ) then

	InventoryMenu:RemoveTitleBar();
	InventoryMenu:Remove();
	InventoryMenu = nil;
	
end

ActiveInventory = 1;
ChosenItem = { id = "", x = -1, y = -1 };

GRIDWIDTH = 50;
GRIDHEIGHT = 50;

function ResetItemData()

	ChosenItem.id = "";
	ChosenItem.x = -1;
	ChosenItem.y = -1;
	
	if( InventoryMenu.DescriptionPanel.Icon ) then
	
		InventoryMenu.DescriptionPanel.Icon:Remove();
		InventoryMenu.DescriptionPanel.Icon = nil;
		
	end
	
	InventoryMenu.DescriptionPanel.PaintHook = nil;
	
end

function CreateInventoryMenu()

	InventoryMenu = CreateBPanel( "Inventory", 35, 10, 470, 565 );
	InventoryMenu:CanClose( false );
	
	InventoryMenu.Think = function()

		if( InventoryMenu.StorageButton ) then
		
			if( not StorageMenu or not StorageMenu:IsVisible() ) then
			
				InventoryMenu.StorageButton:Remove();
				InventoryMenu.StorageButton = nil;
			
			end
		
		end
	
	end
	
	InventoryMenu:SetBodyColor( Color( 20, 20, 20, 100 ) );
	
	InventoryMenu.InventoryPanel = CreateBPanel( nil, 10, 0, 450, 55 );
	InventoryMenu.InventoryPanel:SetParent( InventoryMenu );
	InventoryMenu.InventoryPanel:SetBodyColor( Color( 30, 30, 30, 170 ) );
	InventoryMenu.InventoryPanel:EnableScrolling( true );
	
	InventoryMenu.DescriptionPanel = CreateBPanel( nil, 10, 80, 450, 128 );
	InventoryMenu.DescriptionPanel:SetParent( InventoryMenu );
	InventoryMenu.DescriptionPanel:SetBodyColor( Color( 0, 0, 0, 170 ) );

	InventoryMenu.ContentPanel = CreateBPanel( nil, 10, 235, 450, 298 );	
	InventoryMenu.ContentPanel:SetParent( InventoryMenu );
	InventoryMenu.ContentPanel:SetBodyColor( Color( 30, 30, 30, 170 ) );
	
	InventoryMenu.ContentPanel.OnMousePressed = function()
	
		if( ChosenItem.id ~= "" ) then
		
			ResetItemData();
			RemoveItemButtons();
		
		end
	
	end
	
	InventoryMenu.ContentPanel.PaintHook = function()
	
		local row = InventoryList[ActiveInventory].Height - 1;
		local col = InventoryList[ActiveInventory].Width - 1;
		
		local black = false;
		local newblack = true;
		
		for y = 0, row do
		
			for x = 0, col do
			
				if( black ) then
					draw.RoundedBox( 0, x * GRIDWIDTH, y * GRIDHEIGHT, GRIDWIDTH, GRIDHEIGHT, Color( 0, 0, 0, 200 ) );
				end
				
				black = !black;
				
			end
			
			black = newblack;
			newblack = !newblack;
		
		end
	
		if( ChosenItem.x > -1 ) then
		
			draw.RoundedBox( 0, ChosenItem.x * GRIDWIDTH, ChosenItem.y * GRIDHEIGHT, GRIDWIDTH * TS.ItemsData[ChosenItem.id].Width, GRIDHEIGHT * TS.ItemsData[ChosenItem.id].Height, Color( 0, 0, 128, 128 ) );
		
		end
	
	end

end

function event.ResetInventory()

	CreateInventoryMenu();
	InventoryMenu:SetVisible( false );
	InventoryMenu.TitleBar:SetVisible( false );
	
	ActiveInventory = 1;

	InventoryList = { }
	InventoryIconGrid = { }
	InventoryGrid = { }	

	for n = 1, TS.MaxInventories do
	
		InventoryList[n] = { }
		InventoryList[n].Name = "";
		InventoryList[n].Width = 9;
		InventoryList[n].Height = 6;
	
		InventoryIconGrid[n] = { }
		InventoryGrid[n] = { }
		
		for x = 0, 8 do
		
			InventoryIconGrid[n][x] = { }
			InventoryGrid[n][x] = { }
		
			for y = 0, 5 do
			
				InventoryIconGrid[n][x][y] = { }
				InventoryGrid[n][x][y] = { }
				InventoryGrid[n][x][y].Filled = false;
				
			end
		
		end
		
	end

end

event.ResetInventory();

function RemoveItemButtons()

	if( InventoryMenu.UseButton ) then
		InventoryMenu.UseButton:Remove();
		InventoryMenu.UseButton = nil;
	end
	
	if( InventoryMenu.TuneButton ) then
		InventoryMenu.TuneButton:Remove();
		InventoryMenu.TuneButton = nil;
	end
	
	if( InventoryMenu.DropButton ) then
		InventoryMenu.DropButton:Remove();
		InventoryMenu.DropButton = nil;
	end
	
	if( InventoryMenu.StorageButton ) then
		InventoryMenu.StorageButton:Remove();
		InventoryMenu.StorageButton = nil;
	end
	
	if( InventoryMenu.LookInsideButton ) then
		InventoryMenu.LookInsideButton:Remove();
		InventoryMenu.LookInsideButton = nil;
	end
	
end

function SetAllInventoryIconsVisibility( id, bool )

	for y = 0, InventoryList[id].Height - 1 do
		
		for x = 0, InventoryList[id].Width - 1 do

			if( InventoryIconGrid[id][x][y] and InventoryIconGrid[id][x][y].IsValid and InventoryIconGrid[id][x][y]:IsValid() ) then
				InventoryIconGrid[id][x][y]:SetVisible( bool );
			end
			
		end
		
	end

end

local VestOnID = "";
local VestOn = false;
local LastAction = 0;

function ToggleVest()
	
	if( VestOnID == "" ) then return; end
	
	VestOn = false;
	
	if( InventoryMenu.TakeOffInventoryButton ) then
		InventoryMenu.TakeOffInventoryButton:Remove()
	end
	
	MakePutOn( VestOnID );
	VestOnID = "";

end
usermessage.Hook( "TV", ToggleVest );

function MakePutOn( id )
	
	InventoryMenu.PutOnInventoryButton = InventoryMenu:AddButton( "Wear", 105, 77, function()
	
		if( CurTime() - LastAction < 2.3 ) then return; end
		
		LastAction = CurTime();
		
		RunConsoleCommand( "eng_putonstorage", InventoryList[id].Name );
		
		if( InventoryMenu.PutOnInventoryButton ) then
			InventoryMenu.PutOnInventoryButton:Remove()
		end
		
		MakeTakeOff( id );
		VestOn = true;
		VestOnID = id;
		
	end );
	
end

function MakeTakeOff( id )
	
	InventoryMenu.TakeOffInventoryButton = InventoryMenu:AddButton( "Take off", 105, 77, function()
	
		if( CurTime() - LastAction < 2.3 ) then return; end
		
		LastAction = CurTime();
	
		RunConsoleCommand( "eng_takeoffstorage", InventoryList[id].Name );
		
		if( InventoryMenu.TakeOffInventoryButton ) then
			InventoryMenu.TakeOffInventoryButton:Remove()
		end
	
		MakePutOn( id );
		VestOn = false;
		VestOnID = "";

	end );
	
end

function SetActiveInventory( id )

	if( id == ActiveInventory ) then return; end
	
	if( InventoryMenu.RemoveInventoryButton ) then
		InventoryMenu.RemoveInventoryButton:Remove();
		InventoryMenu.RemoveInventoryButton = nil;
	end
	
	if( InventoryMenu.PutOnInventoryButton ) then
		InventoryMenu.PutOnInventoryButton:Remove();
		InventoryMenu.PutOnInventoryButton = nil;
	end
	
	if( InventoryMenu.TakeOffInventoryButton ) then
		InventoryMenu.TakeOffInventoryButton:Remove();
		InventoryMenu.TakeOffInventoryButton = nil;
	end

	SetAllInventoryIconsVisibility( ActiveInventory, false );
	SetAllInventoryIconsVisibility( id, true );

	ActiveInventory = id;
	
	if( InventoryMenu.DescriptionPanel.Icon ) then
		InventoryMenu.DescriptionPanel.Icon:Remove();
		InventoryMenu.DescriptionPanel.Icon = nil;
	end
	
	InventoryMenu.DescriptionPanel.PaintHook = nil;
	
	RemoveItemButtons();
	
	if( not InventoryList[id].Permanent ) then
	
		InventoryMenu.RemoveInventoryButton = InventoryMenu:AddButton( "Drop storage", 10, 77, function() 
	
			RunConsoleCommand( "eng_invdropstorage", InventoryList[id].Name ); 
		
			if(	StorageActiveInventory == ActiveInventory and StorageMenu and StorageMenu:IsValid() ) then
		
				StorageMenu:Remove();
		
			end
		
		end );

		--You cannot wear or take off backpacks
		if(	InventoryList[id].Name ~= "Backpack" ) then
		
			if( VestOn ) then
			
				MakeTakeOff( id );
			
			else
			
				MakePutOn( id );
			
			end
			
		end
		
	end
	
	ChosenItem.id = "";
	ChosenItem.x = -1;
	ChosenItem.y = -1;
	
	for k, v in pairs( InventoryMenu.InventoryPanel.ScrollingObjects ) do
	
		if( v.IsLink ) then

			if( InventoryMenu.InventoryPanel.ScrollingObjects[k].Text == InventoryList[id].Name ) then
				InventoryMenu.InventoryPanel.ScrollingObjects[k].NormalColor = Color( 0, 75, 200, 200 );
			else
				InventoryMenu.InventoryPanel.ScrollingObjects[k].NormalColor = Color( 255, 255, 255, 255 );
			end

		end
	
	end	

end

function RefreshInventoryList()

	for k, v in pairs( InventoryMenu.InventoryPanel.ScrollingObjects ) do
	
		if( v.IsLink ) then
			InventoryMenu.InventoryPanel.ScrollingObjects[k]:Remove();
			InventoryMenu.InventoryPanel.ScrollingObjects[k] = nil;
		end
	
	end

	local count = 0;

	for n = 1, TS.MaxInventories do
	
		if( InventoryList[n].Name ~= "" ) then
		
			local link = InventoryMenu.InventoryPanel:AddLink( InventoryList[n].Name, "NewChatFont", 5, 5 + 16 * count, Color( 0, 75, 200, 200 ), function() SetActiveInventory( n ); end );
			
			if( n == ActiveInventory ) then
			
				link.NormalColor = Color( 0, 75, 200, 200 );
			
			end
			
			count = count + 1;
			
		end
		
	end

end

function ShowItemButtons( item )

	RemoveItemButtons();

	local itemflags = TS.ItemsData[item].Flags;
	
	local UseItem = function()
	
		RemoveItemButtons();
		RunConsoleCommand( "eng_invuseitem", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y );

	end
	
	local UseItemPortion = function()

		RunConsoleCommand( "eng_invuseitemportion", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y );

	end
	
	local DropItem = function()
	
		if(	StorageItemID == ChosenItem.id and
			StorageActiveInventory == ActiveInventory and
			StorageItemX == ChosenItem.x and
			StorageItemY == ChosenItem.y and StorageMenu and StorageMenu:IsValid() ) then
			
			StorageMenu:Remove();
			
		end
		
		RemoveItemButtons();
	
		RunConsoleCommand( "eng_invdropitem", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y );
	
	end
	
	local AddStorage = function()
	
		RemoveItemButtons();
		RunConsoleCommand( "eng_invaddstorage", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y );	
	
	end
	
	local TuneRadio = function()
	
		PromptRadioMenu();
		
	end
	
	local xoffset = 10;
	
	local AddButton = function( cmd, func )
	
		local button = InventoryMenu:AddButton( cmd, xoffset, 230, func );
		xoffset = button:GetSize() + xoffset + 5;
	
		return button;
	
	end
	
	if( string.find( itemflags, "t" ) ) then
		InventoryMenu.TuneButton = AddButton( "Tune in", TuneRadio ); 
	end
	
	if( string.find( itemflags, "e" ) ) then
		InventoryMenu.UseButton = AddButton( "Eat", UseItem ); 
	end

	if( string.find( itemflags, "d" ) ) then
		if( string.find( itemflags, "@" ) ) then
			InventoryMenu.UseButton = AddButton( "Drink some", UseItemPortion ); 
		else
			InventoryMenu.UseButton = AddButton( "Drink", UseItem ); 
		end
	end

	if( string.find( itemflags, "u" ) ) then
		InventoryMenu.UseButton = AddButton( "Use", UseItem ); 
	end
	
	if( string.find( itemflags, "p" ) ) then
		InventoryMenu.UseButton = AddButton( "Write", function() RemoveItemButtons(); RunConsoleCommand( "eng_invwriteitem", ActiveInventory, ChosenItem.x, ChosenItem.y ); end ); 
	end
	
	if( string.find( itemflags, "l" ) ) then
		InventoryMenu.UseButton = AddButton( "Read", function() RunConsoleCommand( "eng_invuseitem", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y, 1 ); end ); 
	end
	
	if( string.find( itemflags, "W" ) ) then
		InventoryMenu.UseButton = AddButton( "Read", function() RunConsoleCommand( "eng_invuseitem", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y, 1 ); end ); 
	end
	
	InventoryMenu.DropButton = AddButton( "Drop", DropItem ); 
	
	if( not string.find( TS.ItemsData[item].Flags, "c" ) and StorageMenu and StorageMenu:IsVisible() and StorageMenu.CanPutInto ) then
		InventoryMenu.StorageButton = AddButton( "Put into storage", AddStorage );
	end
	
	if( string.find( itemflags, "C" ) or string.find( itemflags, "W" ) ) then
		
		InventoryMenu.LookInsideButton = AddButton( "Look inside", function() 
		
			StorageItemID = ChosenItem.id; 
			StorageActiveInventory = ActiveInventory; 
			StorageItemX = ChosenItem.x; 
			StorageItemY = ChosenItem.y; 

			RunConsoleCommand( "eng_invlookinsidecontainer", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y ); 
			
			if( InventoryMenu.StorageButton and InventoryMenu.StorageButton:IsValid() ) then
				InventoryMenu.StorageButton:Remove();
			end	
		
		end );
		
	end
	
end

function ShowItemDescription( item )

	if( InventoryMenu.DescriptionPanel.Icon ) then
		InventoryMenu.DescriptionPanel.Icon:Remove();
		InventoryMenu.DescriptionPanel.Icon = nil;
	end
	
	local data = TS.ItemsData[item];
	
	InventoryMenu.DescriptionPanel.Icon = vgui.Create( "DModelPanel", InventoryMenu.DescriptionPanel );
	InventoryMenu.DescriptionPanel.Icon:SetModel( data.Model );
	InventoryMenu.DescriptionPanel.Icon:SetPos( 2, 2 );
	InventoryMenu.DescriptionPanel.Icon:SetSize( math.Clamp( data.Width * GRIDWIDTH * 2, 0, InventoryMenu.DescriptionPanel:GetWide() ), math.Clamp( data.Height * GRIDHEIGHT * 2, 0, InventoryMenu.DescriptionPanel:GetTall() ) );
	InventoryMenu.DescriptionPanel.Icon:SetCamPos( data.CamPos );
	InventoryMenu.DescriptionPanel.Icon:SetLookAt( data.LookAt );
	InventoryMenu.DescriptionPanel.Icon:SetFOV( data.Fov );
	InventoryMenu.DescriptionPanel.Text = FormatLine( data.Desc, "NewChatFont", InventoryMenu.DescriptionPanel:GetWide() - math.Clamp( data.Width * GRIDWIDTH * 2, 0, InventoryMenu.DescriptionPanel:GetWide() ) );
	
	InventoryMenu.DescriptionPanel.PaintHook = function()
	
		draw.DrawText( data.Name, "NewChatFont", InventoryMenu.DescriptionPanel:GetWide() - 5, 2, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( InventoryMenu.DescriptionPanel.Text, "NewChatFont", InventoryMenu.DescriptionPanel:GetWide() - 2, 18, Color( 255, 255, 255, 255 ), 2 );
		
	end
	
	InventoryMenu.DescriptionPanel.Icon.LayoutEntity = function( self ) 
	
	end
	
end

function CreateItemDragging( item )
	
	local data = TS.ItemsData[item];
	local mx, my = gui.MousePos();
	
	dragicon = vgui.Create( "DModelPanel", InventoryMenu.ContentPanel );
	dragicon:SetModel( data.Model );
	dragicon:SetPos( mx, my );
	dragicon:SetSize( data.Width * GRIDWIDTH, data.Height * GRIDHEIGHT );
	dragicon:SetCamPos( data.CamPos );
	dragicon:SetLookAt( data.LookAt );
	dragicon:SetFOV( data.Fov );
	dragicon:SetAmbientLight( Color( 255, 255, 255, 255 ) );
	dragicon:MakePopup();
	
	dragicon.Dragging = true;
	
	dragicon.LayoutEntity = function( self ) 
	
	end
	
	dragicon.Think = function()

		local mx, my = gui.MousePos();

		dragicon:SetPos( mx - ( dragicon:GetWide() * 0.5 ), my - ( dragicon:GetTall() * 0.5 ) );
		
		if( not input.IsMouseDown( MOUSE_LEFT ) ) then
		
			local x, y = InventoryMenu:GetPos();

			if( MouseInArea( x + 9, y + 250, 651, 557 ) ) then
			
				local kx = x + 9;
				local ky = y + 235;
				local dx = math.ceil( ( mx - kx ) / 50 ) - 1;
				local dy = math.ceil( ( my - ky ) / 50 ) - 1;

				RunConsoleCommand( "eng_dragdropitem", ChosenItem.id, ActiveInventory, ChosenItem.x, ChosenItem.y, dx, dy );
				
				ResetItemData();
				RemoveItemButtons();
				
			end
			
			dragicon.Dragging = false;
		
			dragicon:Remove();
			dragicon = nil;

		end
	
	end

end

function AddToInventory( id, item, x, y )

	local data = TS.ItemsData[item];

	local icon = vgui.Create( "BModelPanel", InventoryMenu.ContentPanel );
	icon:SetModel( data.Model );
	icon:SetPos( x * GRIDWIDTH, y * GRIDHEIGHT );
	icon:SetSize( data.Width * GRIDWIDTH, data.Height * GRIDHEIGHT );
	icon:SetCamPos( data.CamPos );
	icon:SetLookAt( data.LookAt );
	icon:SetFOV( data.Fov );
	
	icon.PaintHook = function()
	
		if( InventoryGrid[id][x][y].Amount > 1 ) then
		
			local w, h = icon:GetSize();
		
			draw.DrawText( InventoryGrid[id][x][y].Amount, "NewChatFont", w - 5, h - 20, Color( 255, 255, 255, 220 ), 2 );
		
		end
	
	end
	
	icon.LayoutEntity = function( self )
	    

 	end
 	
 	icon.OnMousePressed = function()
 	
 		ChosenItem = { id = item, x = x, y = y };
		
 		ShowItemDescription( item );
 		ShowItemButtons( item );
		
		timer.Simple( .3, function()
		
			if( input.IsMouseDown( MOUSE_LEFT ) ) then
			
				CreateItemDragging( item );
				return;
			
			end
		
		end );
		
 	end
 	
 	InventoryIconGrid[id][x][y] = icon;

	if( ActiveInventory == id ) then
		InventoryIconGrid[id][x][y]:SetVisible( true );
	else
		InventoryIconGrid[id][x][y]:SetVisible( false );
	end

end

function CanFitAt( id, x, y, w, h )

	for k = 0, h - 1 do
	
		for j = 0, w - 1 do
		
			if( x + j >= InventoryList[id].Width or
				y + k >= InventoryList[id].Height ) then
				
				return false;
				
			end
	
			if( not InventoryGrid[id][x + j] or not InventoryGrid[id][x + j][y + k] ) then
			
				return false;
			
			end
	
			if( InventoryGrid[id][x + j][y + k].Filled ) then
			
				return false;
			
			end
		
		end
	
	end
	
	return true;

end

function FindFreeSpace( id, w, h )

	for y = 0, InventoryList[id].Height - 1 do
		
		for x = 0, InventoryList[id].Width - 1 do
		
			if( InventoryGrid[id][x] and InventoryGrid[id][x][y] and ( not InventoryGrid[id][x][y].Filled and CanFitAt( id, x, y, w, h ) ) ) then
			
				return x, y;
			
			end
		
		end
	
	end
	
	return false;

end

function InsertIntoInventory( id, x, y, w, h, amount )

	for j = 0, w - 1 do
	
		for k = 0, h - 1 do

			InventoryGrid[id][x + j][y + k].Filled = true;
			InventoryGrid[id][x + j][y + k].X = x;
			InventoryGrid[id][x + j][y + k].Y = y;

		end
	
	end
	
	InventoryGrid[id][x][y].Amount = amount;

end

local function ReceiveNewItem( msg )

	local inv = msg:ReadShort();
	local id = msg:ReadString();
	local amt = msg:ReadShort();

	if( not TS.ItemsData[id] ) then return; end

	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;

	local x, y = FindFreeSpace( inv, w, h );

	if( x and y ) then
	
		InsertIntoInventory( inv, x, y, w, h, amt );
	
		AddToInventory( inv, id, x, y );
	
	end

end 
usermessage.Hook( "RNI", ReceiveNewItem );

local function ReceiveNewSavedItem( msg )

	local inv = msg:ReadShort();
	local id = msg:ReadString();
	local x = msg:ReadShort();
	local y = msg:ReadShort();
	local amt = msg:ReadShort();

	if( not TS.ItemsData[id] ) then return; end

	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;

	InsertIntoInventory( inv, x, y, w, h, amt );
	
	AddToInventory( inv, id, x, y );

end 
usermessage.Hook( "RNSI", ReceiveNewSavedItem );

local function UpdateItemAmount( msg )

	local inv = msg:ReadShort();
	local x = msg:ReadShort();
	local y = msg:ReadShort();
	local amt = msg:ReadShort();

	InventoryGrid[inv][x][y].Amount = amt;

end
usermessage.Hook( "UIA", UpdateItemAmount );

local function RemoveItemInventory( msg )

	local iid = msg:ReadShort();
	local x = msg:ReadShort();
	local y = msg:ReadShort();

	for k, v in pairs( InventoryGrid[iid] ) do
	
		for n, m in pairs( v ) do
		
			if( m.X == x and m.Y == y ) then
			
				InventoryGrid[iid][k][n].Filled = false;
				InventoryGrid[iid][k][n].X = -1;
				InventoryGrid[iid][k][n].Y = -1;
				
			end
		
		end
	
	end
	
	if( InventoryIconGrid[iid][x][y] and InventoryIconGrid[iid][x][y].Remove ) then
		InventoryIconGrid[iid][x][y]:Remove();
		InventoryIconGrid[iid][x][y] = nil;
	end
	
	if( ChosenItem.x == x and
		ChosenItem.y == y and
		ActiveInventory == iid ) then
		
		RemoveItemButtons();
		ChosenItem.id = "";
		ChosenItem.x = -1;
		ChosenItem.y = -1;
		
		if( InventoryMenu.DescriptionPanel.Icon ) then
			InventoryMenu.DescriptionPanel.Icon:Remove();
			InventoryMenu.DescriptionPanel.Icon = nil;
		end
		
		InventoryMenu.DescriptionPanel.PaintHook = nil;
		
	end
	

end
usermessage.Hook( "RII", RemoveItemInventory );

local FirstInventory = false;

local function RemoveInventory( msg )

	local name = msg:ReadString();

	for n = 1, TS.MaxInventories do
	
		if( InventoryList[n].Name == name ) then
		
			InventoryList[n].Name = "";
			
			for k, v in pairs( InventoryGrid[n] ) do
			
				for i, m in pairs( v ) do
				
					InventoryGrid[n][k][i].Filled = false;
					InventoryGrid[n][k][i].X = -1;
					InventoryGrid[n][k][i].Y = -1;
						
					if( InventoryIconGrid[n][k][i] and InventoryIconGrid[n][k][i].Remove ) then
						InventoryIconGrid[n][k][i]:Remove();
						InventoryIconGrid[n][k][i] = nil;
					end
				
				end
			
			end
			
			if( n == ActiveInventory ) then
				SetActiveInventory( 1 );
			end
		
			RefreshInventoryList();
		
		end
		
	end

end
usermessage.Hook( "RINV", RemoveInventory );

local function AddNewInventory( msg )

	local name = msg:ReadString();
	local w = msg:ReadShort();
	local h = msg:ReadShort();
	local p = msg:ReadBool();

	for n = 1, TS.MaxInventories do
	
		if( InventoryList[n].Name == "" ) then
		
			InventoryList[n].Name = name;
			InventoryList[n].Width = w;
			InventoryList[n].Height = h;
			InventoryList[n].Permanent = p;
			
			RefreshInventoryList();
			
			if( not FirstInventory ) then --Do this to set the initial inventory color to blue (usually Pockets)
			
				FirstInventory = true;
	
				if( n == ActiveInventory ) then
					SetActiveInventory( n );
				end
				
			end
			
			return;
		
		end
		
	end
	
	
end
usermessage.Hook( "ANI", AddNewInventory );
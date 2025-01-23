
if( StorageMenu ) then
	StorageMenu:Remove();
end
StorageMenu = nil;

StorageIconGrid = { }
StorageW = 0;
StorageH = 0;
 
function RemoveAllStorageIcons()

	for k, v in pairs( StorageIconGrid ) do
	
		for n, m in pairs( v ) do
		
			if( StorageIconGrid[k][n]:IsValid() ) then
				StorageIconGrid[k][n]:Remove();
				StorageIconGrid[k][n] = nil;
			end
			
		end
	
	end
	
	StorageIconGrid = nil;
	StorageIconGrid = { }
	
	ChosenStorageItem = nil;

end

function RemoveStorageButtons()

	if( not StorageMenu ) then return; end

	if( StorageMenu.TakeButton ) then
		StorageMenu.TakeButton:Remove();
		StorageMenu.TakeButton = nil;
	end

end

function ShowStorageButtons()

	local function take()
	
		local room = false;
	
		for n = 1, TS.MaxInventories do
		
			if( InventoryList[n].Name ~= "" ) then
			
				if( FindFreeSpace( n, TS.ItemsData[ChosenStorageItem.id].Width, TS.ItemsData[ChosenStorageItem.id].Height ) ) then
				
					if( string.find( StorageMenu.Flags, "C" ) ) then
						RunConsoleCommand( "eng_invtakeinvstoritem", StorageItemID, StorageActiveInventory, StorageItemX, StorageItemY, ChosenStorageItem.id, ChosenStorageItem.x, ChosenStorageItem.y );
					else
						RunConsoleCommand( "eng_invtakestorageitem", ChosenStorageItem.id, ChosenStorageItem.x, ChosenStorageItem.y );
					end
					
					room = true;
					break;
					
				end
			
			end
		
		end
		
		if( not room ) then
		
			CreateOkPanel( "No room", "No room for item" );
		
		end
	
	end

	StorageMenu.TakeButton = StorageMenu:AddButton( "Take", 10, 10, take );

end

function CreateStorageMenu( msg )

	if( StorageMenu ) then
		StorageMenu:Remove();
		StorageMenu = nil;
	end
	
	RemoveAllStorageIcons();
	RemoveStorageButtons();
	
	if( not PlayerMenuVisible ) then
		TogglePlayerMenu();
	end

	local title = msg:ReadString();
	StorageW = msg:ReadShort();
	StorageH = msg:ReadShort();
	local flags = msg:ReadString();

	StorageMenu = CreateBPanel( title, 10, 10, 475, 350 );
	StorageMenu:SetBodyColor( Color( 20, 20, 20, 100 ) );

	StorageMenu.Flags = flags;

	if( string.find( flags, "C" ) ) then
		StorageMenu.CanPutInto = false;
	else
		StorageMenu.CanPutInto = true;
	end
	
	StorageMenu.ContentPanel = CreateBPanel( nil, 10, 20, 450, 298 );	
	StorageMenu.ContentPanel:SetParent( StorageMenu );
	StorageMenu.ContentPanel:SetBodyColor( Color( 30, 30, 30, 170 ) );
	
	StorageMenu.ContentPanel.PaintHook = function()
	
		local row = StorageH - 1;
		local col = StorageW - 1;
		
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
	
		if( ChosenStorageItem and ChosenStorageItem.x > -1 ) then
		
			draw.RoundedBox( 0, ChosenStorageItem.x * GRIDWIDTH, ChosenStorageItem.y * GRIDHEIGHT, GRIDWIDTH * TS.ItemsData[ChosenStorageItem.id].Width, GRIDHEIGHT * TS.ItemsData[ChosenStorageItem.id].Height, Color( 0, 0, 128, 128 ) );
		
		end
	
	end
	
	function StorageMenu:OnClose()
	
		if( StorageMenu ) then
		
			StorageMenu:Remove();
			RemoveAllStorageIcons();
		
		end
		
		StorageMenu = nil;
	
	end

end
usermessage.Hook( "CSM", CreateStorageMenu );

function InsertStorageItem( msg )

	if( not StorageMenu ) then return; end

	local item = msg:ReadString();
	local x = msg:ReadShort();
	local y = msg:ReadShort();

	local data = TS.ItemsData[item];
	
	if( not data ) then timer.Simple( 1, InsertStorageItem, msg ); return; end
	
	local icon = vgui.Create( "DModelPanel", StorageMenu.ContentPanel );
	icon:SetModel( data.Model );
	icon:SetPos( x * GRIDWIDTH, y * GRIDHEIGHT );
	icon:SetSize( data.Width * GRIDWIDTH, data.Height * GRIDHEIGHT );
	icon:SetCamPos( data.CamPos );
	icon:SetLookAt( data.LookAt );
	icon:SetFOV( data.Fov );
	
	icon.LayoutEntity = function( self )
	

 	end
 	
 	icon.OnMousePressed = function()
 	
 		ChosenStorageItem = { id = item, x = x, y = y };
 		ShowStorageButtons();
 	
 	end
 	
 	if( StorageIconGrid[x] and StorageIconGrid[x][y] ) then

 		if( StorageIconGrid[x][y]:IsValid() ) then
 			StorageIconGrid[x][y]:Remove();
 		end
 		
 		StorageIconGrid[x][y] = nil;
 		
 	end
 	
 	if( not StorageIconGrid[x] ) then
 		StorageIconGrid[x] = { }
 	end
 	
 	StorageIconGrid[x][y] = icon;


end
usermessage.Hook( "ISI", InsertStorageItem );

function RemoveStorageItem( msg )

	local x = msg:ReadShort();
	local y = msg:ReadShort();

	if( ChosenStorageItem and
		ChosenStorageItem.x == x and
		ChosenStorageItem.y == y ) then
		
		ChosenStorageItem = nil;
		RemoveStorageButtons();
		
	end

	if( StorageIconGrid[x] and StorageIconGrid[x][y] ) then
	
		StorageIconGrid[x][y]:Remove();
		StorageIconGrid[x][y] = nil;
		
	end
	

end
usermessage.Hook( "RSI", RemoveStorageItem );

function NoRoomInStorage()

	CreateOkPanel( "No room", "No room for item" );

end
usermessage.Hook( "NRIS", NoRoomInStorage );


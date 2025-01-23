
InventoryLinks = { }
InventoryList = { }
InventoryWindows = { }
InventoryItems = { }
InventorySelection = { }
InventoryItemList = { }

INV_COL_WIDTH = 50
INV_COL_HEIGHT = 50

function InventoryPaint()

	if( ClientVars["Class"] == "Infected" ) then return; end

	draw.RoundedBox( 0, ScrW() - 300, ScrH() - 160, 280, 130, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 0, ScrW() - 298, ScrH() - 158, 276, 126, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 0, ScrW() - 300, ScrH() - 160, 95, 18, Color( 255, 255, 255, 255 ) );
	draw.DrawText( "Heavy Weaponry", "ActionMenuOption", ScrW() - 297, ScrH() - 160, Color( 0, 0, 0, 255 ) );

	if( CurrentHeavyWeapon ) then
		
		local weap = nil;
		
		for _, v in pairs( LocalPlayer():GetWeapons() ) do
			
			if( v:GetClass() == CurrentHeavyWeapon ) then
				
				weap = v;
				
			end
			
		end
	
		if( weap and weap:IsValid() and weap:GetTable() and weap.HealthAmt and weap:GetTable().Degrades ) then
		
			local perc = weap.HealthAmt / 100;
		
			draw.RoundedBox( 0, ScrW() - 200, ScrH() - 153, 170, 9, Color( 255, 255, 255, 120 ) );
	
			if( weap.HealthAmt > 3 ) then
				
				draw.RoundedBox( 0, ScrW() - 199, ScrH() - 152, 168 * perc, 7, Color( 0, 200, 0, 255 ) );
				draw.RoundedBox( 0, ScrW() - 199, ScrH() - 152, 168 * perc, 4, Color( 255, 255, 255, 50 ) );
			
			end
		
		end
		
	end

	draw.RoundedBox( 0, ScrW() - 200, ScrH() - 280, 180, 110, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 0, ScrW() - 198, ScrH() - 278, 176, 106, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 0, ScrW() - 200, ScrH() - 280, 91, 18, Color( 255, 255, 255, 255 ) );
	draw.DrawText( "Light Weaponry", "ActionMenuOption", ScrW() - 197, ScrH() - 280, Color( 0, 0, 0, 255 ) );
	
	if( CurrentLightWeapon ) then
	
		local weap = nil;
		
		for _, v in pairs( LocalPlayer():GetWeapons() ) do
			
			if( v:GetClass() == CurrentLightWeapon ) then
				
				weap = v;
				
			end
			
		end
	
		if( weap and weap:IsValid() and weap:GetTable() and weap.HealthAmt and weap.Degrades ) then
		
			local perc = weap.HealthAmt / 100;
		
			draw.RoundedBox( 0, ScrW() - 105, ScrH() - 275, 80, 9, Color( 255, 255, 255, 120 ) );
	
			if( weap.HealthAmt > 3 ) then
				
				draw.RoundedBox( 0, ScrW() - 104, ScrH() - 274, 78 * perc, 7, Color( 0, 200, 0, 255 ) );
				draw.RoundedBox( 0, ScrW() - 104, ScrH() - 274, 78 * perc, 4, Color( 255, 255, 255, 50 ) );
			
			end
		
		end
		
	end
	
end

function GetInventoryMouseIsIn()

	for k, v in pairs( InventoryWindows ) do
	
		if( v:IsValid() and v:IsVisible() ) then
	
			local x, y = v:GetPos();
			local w, h = v:GetSize();
			
			if( CursorInArea( x, y, w, h ) ) then
			
				return k;
			
			end
			
		end
		
	end
	
	return nil;

end

function StartItemDragging( model, campos, lookat, fov, width, height )

	local mx, my = gui.MousePos();

	InventorySelection.DragIcon = CreateModelIcon( model, campos, lookat, fov );
	InventorySelection.DragIcon:SetPos( mx - width * .5, my - height * .5 );
	InventorySelection.DragIcon:SetSize( width, height );	
	InventorySelection.DragIcon:MakePopup();
	
	InventorySelection.DragIcon.Think = function()
		
		if( InventorySelection.DragIcon ) then
			
			local mx, my = gui.MousePos();

			InventorySelection.DragIcon:SetPos( mx - width * .5, my - height * .5 );

			if( not input.IsMouseDown( MOUSE_LEFT ) ) then
			
				local inv = GetInventoryMouseIsIn();
		
				if( inv ) then
					
					local x, y = InventoryWindows[inv]:GetPos();
					
					local dx = math.ceil( ( mx - x ) / INV_COL_WIDTH );
					local dy = math.ceil( ( my - y ) / INV_COL_HEIGHT );

					if( InventorySelection.weapon ) then
					
						if( InventorySelection.lightweap ) then
							
							RunConsoleCommand( "eng_lweaptoinv", inv, dx, dy );
							
						end
						
						if( InventorySelection.heavyweap ) then
							
							RunConsoleCommand( "eng_hweaptoinv", inv, dx, dy );
							
						end
						
						InventorySelection.dragging = false;
						InventorySelection.DragIcon:Remove();
						InventorySelection.DragIcon = nil;
											
						return;
					
					end

					if( InventorySelection and not ( InventorySelection.Inv == inv and dx == InventorySelection.tx and dy == InventorySelection.ty ) ) then

						RunConsoleCommand( "eng_minvinv", InventorySelection.tx, InventorySelection.ty, InventorySelection.Inv, inv, dx, dy );
					
					end
			
				else

					--Heavy weapons
					if( CursorInArea( ScrW() - 298, ScrH() - 158, 276, 126 ) ) then

						if( InventorySelection.Inv > 0 ) then
				
							RunConsoleCommand( "eng_invheavyweap", InventorySelection.Inv, InventorySelection.tx, InventorySelection.ty );
					
						end
					
					--Light weapons
					elseif( CursorInArea( ScrW() - 198, ScrH() - 278, 176, 106 ) ) then
					
						if( InventorySelection.Inv > 0 ) then
					
							RunConsoleCommand( "eng_invlightweap", InventorySelection.Inv, InventorySelection.tx, InventorySelection.ty );
						
						end
						
					else
				
						RunConsoleCommand( "eng_dropfrominv", InventorySelection.Inv, InventorySelection.tx, InventorySelection.ty );
				
					end
				
					
				end
				
				InventorySelection.dragging = false;
				InventorySelection.DragIcon:Remove();
				InventorySelection.DragIcon = nil;
				return;

			end
			
		end
	
	end

end

function CreateInventoryIconAt( inv, x, y )

	local item = InventoryItems[inv][x][y];

	InventoryItems[inv][x][y].Icon = CreateModelIcon( item.IconModel, item.IconCamPos, item.IconLookAt, item.IconFov );
	InventoryItems[inv][x][y].Icon:SetParent( InventoryWindows[inv] );
	InventoryItems[inv][x][y].Icon:SetPos( item.IconX, item.IconY );
	InventoryItems[inv][x][y].Icon:SetSize( item.IconW, item.IconH );
	InventoryItems[inv][x][y].Icon:SetAmbientLight( Color( 255, 255, 255, 255 ) );
	
	InventoryItems[inv][x][y].Icon.PaintHook = function()
	
		if( InventoryItems[inv][x][y].Amt > 1 ) then
			draw.DrawText( InventoryItems[inv][x][y].Amt, "Default", item.IconW - 2, item.IconH - 15, Color( 255, 255, 255, 255 ), 2 );
		end
		
	end
	
	InventoryItems[inv][x][y].Icon.OnMousePressed = function( pnl, mc )

		InventorySelection = 
		{
		
			dragging = false,
			weapon = false,
			Inv = inv,
			model = item.IconModel,
			x = item.IconX,
			y = item.IconY,
			w = item.IconW, 
			h = item.IconH,
			tx = x,
			ty = y,
			id = InventoryItems[inv][x][y].id,
		
		};

		if( mc == MOUSE_LEFT ) then
		
			InventorySelection.dragging = true;
			
			StartItemDragging( item.IconModel, item.IconCamPos, item.IconLookAt, item.IconFov, item.IconW, item.IconH );
		
		else
		
			CreateInventoryActionMenu( ItemData[InventorySelection.id] );
	
		end
		
	end
		
end

function RefreshInventoryWindowIcons( id )

	if( InventoryItems[id] ) then
	
		for k, v in pairs( InventoryItems[id] ) do
		
			for n, m in pairs( v ) do
		
				CreateInventoryIconAt( id, k, n );
				
			end
		
		end
		
	end

end

function CreateInventoryWindow( id, x, y )

	if( InventoryWindows[id] and InventoryWindows[id]:IsValid() ) then
	
		return;
	
	end

	InventoryWindows[id] = CreateBPanel( InventoryList[id].Name, x - 3, y + 20, INV_COL_WIDTH * InventoryList[id].w + 10, INV_COL_HEIGHT * InventoryList[id].h + 10 );
	
	RefreshInventoryWindowIcons( id );
	
	InventoryWindows[id].PaintHook = function()
	
		for n = 1, InventoryList[id].w - 1 do
	
			surface.SetDrawColor( 100, 100, 100, 40 );
			surface.DrawLine( n * INV_COL_WIDTH + 5, 0, n * INV_COL_WIDTH + 5, InventoryWindows[id]:GetTall() );
			
		end
	
		for n = 1, InventoryList[id].h - 1 do
	
			surface.SetDrawColor( 100, 100, 100, 40 );
			surface.DrawLine( 0,  n * INV_COL_HEIGHT + 5, InventoryWindows[id]:GetWide(), n * INV_COL_HEIGHT + 5 );
			
		end
		
		if( InventorySelection and InventorySelection.Inv and not InventorySelection.weapon and InventorySelection.Inv == id ) then
		
			draw.RoundedBox( 0, InventorySelection.x, InventorySelection.y, InventorySelection.w, InventorySelection.h, Color( 255, 255, 255, 255 ) );
			draw.RoundedBox( 0, InventorySelection.x + 2, InventorySelection.y + 2, InventorySelection.w - 4, InventorySelection.h - 4, Color( 0, 0, 0, 255 ) );
		
		end
	
	end
	
end

RightClickSelectedInventory = -1;

function OpenTempInventory( name, id, w, h )

	InventoryList[id] = { Name = name, x = ScrW() * .1, y = ScrH() * .1, w = w, h = h, CanDrop = false };	

	CreateInventoryWindow( id, ScrW() * .1, ScrH() * .1 );

end

function msgs.OTI( msg )

	local name = msg:ReadString();
	local w = msg:ReadShort();
	local h = msg:ReadShort();
	
	OpenTempInventory( name, MAX_INVENTORIES, w, h );

end

function AddNewInventory( name, id, x, y, w, h, candrop )

	InventoryList[id] = { Name = name, x = x, y = y, w = w, h = h, CanDrop = candrop };

	local link = vgui.CreateLink();
	link:SetParent( PlayerMenuPanel );
	link:SetPos( x + ScrW() / 2, 400 + y );
	link:SetText( string.gsub( name, " ", "   " ), "OpeningEpidemicLinks" );
	
	link.Action = function()
	
		local x, y = link:GetPos();
	
		CreateInventoryWindow( id, x, y );
	
	end
	
	if( candrop ) then
	
		link.RightAction = function()
		
			CreateInventoryActionMenu( nil, id );
			RightClickSelectedInventory = id;
		
		end
		
	end
	
	InventoryLinks[id] = link;

end

function event.RRM()

	SelectedRadioFreq = -1;

	Radios = { }

	if( RadioMenu ) then

		RadioMenu:Remove();
		
	end
	
	if( RadioWindows ) then
	
		for k, v in pairs( RadioWindows ) do
		
			if( v:IsValid() ) then
			
				v:Remove();
			
			end
		
		end
	
		RadioWindows = { }
	
	end

end

function RemoveFromInventory( inv, x, y )

	local itemid = InventoryItems[inv][x][y].id;

	if( ItemData[itemid] ) then

		if( string.find( ItemData[itemid].flags, "r" ) ) then
	
			local uniqueid = InventoryItems[inv][x][y].UniqueID;
		
			Radios[uniqueid] = nil;
			
			if( RadioMenu and RadioMenu:IsValid() ) then
			
				FillRadioChatMenu();
			
			end
			
			if( SelectedRadioFreq == uniqueid ) then
			
				RunConsoleCommand( "eng_rf", -1, 0 );
				SelectedRadioFreq = -1;
				
			end
			
			if( RadioWindows[uniqueid] ) then
			
				RadioWindows[uniqueid]:Remove();
				RadioWindows[uniqueid] = nil;
			
			end
	
		end	
		
	end
	
	if( not InventoryItems[inv] or
		not InventoryItems[inv][x] or 
		not InventoryItems[inv][x][y] ) then
		return;
	end
	
	for k, v in pairs( InventoryItemList ) do
	
		if( inv == v.Inv and v.x == x and v.y == y ) then
		
			InventoryItemList[k] = nil;
		
		end
	
	end
	
	if( InventoryItems[inv][x][y].Icon and InventoryItems[inv][x][y].Icon:IsValid() ) then
	
		InventoryItems[inv][x][y].Icon:Remove();
		
	end
	
	InventoryItems[inv][x][y] = nil;
	
	if( InventorySelection and InventorySelection.tx == x and InventorySelection.ty == y ) then
	
		if( InventorySelection.DragIcon ) then
	
			InventorySelection.DragIcon:Remove();
			
		end
		
		InventorySelection = nil;
	
	end

end

function msgs.RWINV( msg )

	local inv = msg:ReadShort();
	
	if( InventoryItems[inv] ) then
	
		for x, _ in pairs( InventoryItems[inv] ) do
		
			for y, _ in pairs( InventoryItems[inv][x] ) do
			
				RemoveFromInventory( inv, x, y );
			
			end
		
		end
		
	end

	if( InventoryWindows[inv] and InventoryWindows[inv]:IsValid() ) then
	
		InventoryWindows[inv]:Remove();
		InventoryWindows[inv] = nil;
	
	end
	
	InventoryLinks[inv]:Remove();
	InventoryLinks[inv] = nil;

end

function msgs.RINV( msg )

	local inv = msg:ReadShort();
	local x = msg:ReadShort();
	local y = msg:ReadShort();	
	
	RemoveFromInventory( inv, x, y );

end

function msgs.CIIA( msg )

	local inv = msg:ReadShort();
	local x = msg:ReadShort();
	local y = msg:ReadShort();
	local amt = msg:ReadShort();	
	
	InventoryItems[inv][x][y].Amt = amt;

end

function msgs.IINV( msg )

	local inv = msg:ReadShort();
	local itemid = msg:ReadString();
	local x = msg:ReadShort();
	local y = msg:ReadShort();
	local amt = msg:ReadShort();

	if( not InventoryItems[inv] ) then
		InventoryItems[inv] = { }
	end

	if( not InventoryItems[inv][x] ) then
		InventoryItems[inv][x] = { }
	end
	
	if( string.find( ItemData[itemid].flags, "r" ) ) then
	
		Radios[InvUniqueID] = {
		
			Freq = 0,
			DFreq = 0,
		
		}
	
		if( RadioMenu and RadioMenu:IsValid() ) then
		
			FillRadioChatMenu();
		
		end
	
	end

	InventoryItems[inv][x][y] =
	{
		
		id = itemid,
		IconModel = ItemData[itemid].model,
		IconCamPos = ItemData[itemid].CamPos,
		IconLookAt = ItemData[itemid].LookAt,
		IconFov = ItemData[itemid].Fov,
		IconX = ( ( x - 1 ) * INV_COL_WIDTH ) + 5,
		IconY = ( ( y - 1 ) * INV_COL_HEIGHT ) + 5,
		IconW = ItemData[itemid].w * INV_COL_WIDTH,
		IconH = ItemData[itemid].h * INV_COL_HEIGHT,
		Amt = amt,
		UniqueID = InvUniqueID,
	
	}
	
	InvUniqueID = InvUniqueID + 1;
	
	table.insert( InventoryItemList, { ID = itemid, Inv = inv, x = x, y = y, Flags = ItemData[itemid].flags } );

	if( InventoryWindows[inv] and InventoryWindows[inv]:IsValid() ) then
	
		CreateInventoryIconAt( inv, x, y );
		
	end

end

ToPutInEntityInvX = 1;
ToPutInEntityInvY = 1;
ToPutInEntityInv = { };

function CreateEntityInventory( tab, x, y )
	
	
	
end

function msgs.SEIV( msg )
	
	ToPutInEntityInvX = msg:ReadShort();
	ToPutInEntityInvY = msg:ReadShort();
	
end

function msgs.IEIV( msg )
	
	local inv = 1;
	local itemid = msg:ReadString();
	local x = msg:ReadShort();
	local y = msg:ReadShort();
	local amt = msg:ReadShort();
	
	table.insert( ToPutInEntityInv, { inv, itemid, x, y, amt } );
	
end

function msgs.FEIV( msg )
	
	CreateEntityInventory( ToPutInEntityInv, ToPutInEntityInvX, ToPutInEntityInvY );
	ToPutInEntityInv = { };
	ToPutInEntityInvX = 1;
	ToPutInEntityInvY = 1;
	
end

function msgs.AINV( msg )

	local group = msg:ReadShort();
	local inv = msg:ReadShort();
	local w = msg:ReadShort();
	local h = msg:ReadShort();
	
	local data = PlayerModels[group].Inventories[inv];
	
	AddNewInventory( data.Name, inv, data.x, data.y, w, h, data.CanDrop );

end

function event.CreateDefaultInventories()

	if( InventoryLinks ) then
	
		for k, v in pairs( InventoryLinks ) do
		
			if( v:IsValid() ) then
			
				v:Remove();
			
			end
		
		end
	
	end

	if( InventoryWindows ) then
	
		for k, v in pairs( InventoryWindows ) do
		
			if( v:IsValid() ) then
			
				v:Remove();
			
			end
		
		end
	
	end

	InventoryLinks = { };
	InventoryList = { };
	InventoryWindows = { };
	InventoryItems = { };
	InventorySelection = { };
	InventoryItemList = { };
	
	local iFoundMyPlace = false;

	for k, v in pairs( PlayerModels ) do

		if( table.HasValue( v.Models, string.lower( LocalPlayer():GetModel() ) ) ) then
			
			iFoundMyPlace = true;
			
			for n, m in pairs( v.Inventories ) do
		
				if( m.Default ) then
				
					AddNewInventory( m.Name, n, m.x, m.y, m.w, m.h );
				
				end
			
			end
		
		end
	
	end
	
	if( not iFoundMyPlace ) then
		
		for n, m in pairs( PlayerModels[1].Inventories ) do
			
			if( m.Default ) then
			
				AddNewInventory( m.Name, n, m.x, m.y, m.w, m.h );
			
			end
		
		end
		
	end
	
end

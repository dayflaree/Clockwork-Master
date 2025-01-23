
InvActionMenu = nil;

local function DropInventory()

	RunConsoleCommand( "eng_dropinventory", RightClickSelectedInventory );

end

InvActionOptions =
{
	
	{ Flag = "e", Text = "Eat", Command = "eng_useiteminv" },
	{ Flag = "s", Text = "Smoke", Command = "eng_useiteminv" },
	{ Flag = "d", Text = "Drink", Command = "eng_useiteminv" },
	{ Flag = "r", Text = "Change Frequency", Func = OpenRadioFreq },
	{ Flag = "u", Text = "Use", Command = "eng_useiteminv" },
	{ Flag = "x", Text = "Examine", Command = "eng_exmiteminv" },
	{ Flag = "w", Text = "Unload", Command = "eng_unloadweap" },
	{ Flag = "", Text = "Drop", Command = "eng_dropfrominv" },

}

surface.CreateFont( "Default", 18, 500, true, false, "ActionMenuOptionDesc" );

function CreateInventoryActionMenu( itemdata, inv )

	local mx, my = gui.MousePos();
	
	InvActionMenu = { }
	
	InvActionMenu.MouseStartDown = true;
	InvActionMenu.x = mx;
	InvActionMenu.y = my;
	InvActionMenu.optionwidth = 0;
	InvActionMenu.width = 0;
	InvActionMenu.height = 0;
	
	if( itemdata ) then
	
		InvActionMenu.Desc = FormatLine( itemdata.name .. "- \n" .. itemdata.desc, "ActionMenuOption", 200 );
	
	elseif( inv ) then
	
		InvActionMenu.Desc = FormatLine( InventoryList[inv].Name, "ActionMenuOption", 200 );
	
	end
	
	surface.SetFont( "ActionMenuOption" );
	
	InvActionMenu.Options = { }
	
	if( itemdata ) then
	
		for k, v in pairs( InvActionOptions ) do
		
			if( string.find( itemdata.flags, v.Flag ) ) then
			
				local w, h = surface.GetTextSize( v.Text );
			
				if( InvActionMenu.width < w ) then
					InvActionMenu.width = w + 25;
					InvActionMenu.optionwidth = w;
				end
				
				InvActionMenu.height = InvActionMenu.height + 25;
				
				table.insert( InvActionMenu.Options, { Text = v.Text, Func = v.Func, Command = v.Command, width = w, height = h, } );
				
			end
		
		end
	
	elseif( inv ) then
	
		local w, h = surface.GetTextSize( "Drop" );
		
		InvActionMenu.width = w + 25;
		InvActionMenu.optionwidth = w;
		InvActionMenu.height = InvActionMenu.height + 25;
		
		table.insert( InvActionMenu.Options, { Text = "Drop", Func = DropInventory, width = w, height = h, } );
	
	end
	
	surface.SetFont( "ActionMenuOptionDesc" );
	local w, h = surface.GetTextSize( InvActionMenu.Desc );
	InvActionMenu.width = InvActionMenu.width + w + 5;
	
	if( h > InvActionMenu.height ) then
	
		InvActionMenu.height = h + 20;
		
	end

end

function DrawInventoryActionMenu()

	if( not InvActionMenu ) then
	
		return;
	
	end
	
	draw.RoundedBox( 0, InvActionMenu.x, InvActionMenu.y, InvActionMenu.width, 2, Color( 255, 255, 255, 200 ) );
	draw.RoundedBox( 0, InvActionMenu.x, InvActionMenu.y + 2, 2, InvActionMenu.height - 2, Color( 255, 255, 255, 200 ) );
	draw.RoundedBox( 0, InvActionMenu.x + InvActionMenu.width, InvActionMenu.y, 2, InvActionMenu.height, Color( 255, 255, 255, 200 ) );
	draw.RoundedBox( 0, InvActionMenu.x, InvActionMenu.y + InvActionMenu.height, InvActionMenu.width + 2, 2, Color( 255, 255, 255, 200 ) );
	
	draw.RoundedBox( 0, InvActionMenu.x + 2, InvActionMenu.y + 2, InvActionMenu.width - 2, InvActionMenu.height - 2, Color( 0, 0, 0, 253 ) );

	local y = 5;
	
	local option;

	for k, v in pairs( InvActionMenu.Options ) do
	
		local color = Color( 0, 180, 0, 255 );
		
		if( CursorInArea( 7 + InvActionMenu.x, y + InvActionMenu.y, v.width, v.height ) ) then
		
			color = Color( 0, 100, 0, 255 );
			option = k;
		
		end
	
		draw.DrawText( v.Text, "ActionMenuOption", 7 + InvActionMenu.x, y + InvActionMenu.y, color );
		y = y + 20;
	
	end
	
	draw.DrawText( InvActionMenu.Desc, "ActionMenuOptionDesc", InvActionMenu.x + InvActionMenu.optionwidth + 24, InvActionMenu.y + 5, Color( 255, 255, 255, 255 ) );
	
	draw.RoundedBox( 0, InvActionMenu.x + InvActionMenu.optionwidth + 17, InvActionMenu.y + 4, 2, InvActionMenu.height - 8, Color( 255, 255, 255, 250 ) );

	if( input.IsMouseDown( MOUSE_LEFT ) or input.IsMouseDown( MOUSE_RIGHT ) ) then
	
		if( not InvActionMenu.MouseStartDown ) then

			if( option ) then

				if( InvActionMenu.Options[option].Command ) then
	
					RunConsoleCommand( InvActionMenu.Options[option].Command, InventorySelection.Inv, InventorySelection.tx, InventorySelection.ty );
				
				elseif( InvActionMenu.Options[option].Func ) then
		
					if( InventorySelection ) then
		
						InvActionMenu.Options[option].Func( InventorySelection.Inv, InventorySelection.tx, InventorySelection.ty );
				
					else
					
						InvActionMenu.Options[option].Func();
					
					end
				
				end
				
			end
			
			InvActionMenu = nil;
			
		end
	
	elseif( InvActionMenu.MouseStartDown ) then
	
		InvActionMenu.MouseStartDown = false;
	
	end

end

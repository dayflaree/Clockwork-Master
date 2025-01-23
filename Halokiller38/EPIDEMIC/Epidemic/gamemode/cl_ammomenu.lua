
function CreateAmmoMenu()

	if( AmmoMenu ) then return; end
	
	local sy = ScrH() - 160;
	
	local ammolist = { }
	
	local weap = LocalPlayer():GetActiveWeapon();
	
	if( not weap:IsValid() ) then return; end
	if( not weap:GetTable() ) then return; end
	if( not weap:GetTable().Primary ) then return; end
	if( not weap:GetTable().Primary.AmmoType ) then return; end
	
	local ammotype = weap:GetTable().Primary.AmmoType;
	
	for k, v in pairs( InventoryItemList ) do
	
		if( string.find( v.Flags, "a" ) and string.find( v.Flags, "#" ) ) then
		
			local p = string.find( v.Flags, "#" );
			local type = tonumber( string.sub( v.Flags, p + 1 ) );
		
			if( type and type == ammotype ) then
			
				table.insert( ammolist, { Inv = v.Inv, x = v.x, y = v.y } );
			
			end
		
		end
	
	end
	
	if( #ammolist == 0 ) then return; end
	
	AmmoMenu = CreateBPanel( nil, ScrW() - 90, sy - #ammolist * 52, 60, #ammolist * 52 );
	
	gui.SetMousePos( ScrW() - 90 + 25, sy - #ammolist * 52 + 25 );
	
	for k, v in pairs( ammolist ) do

		local inv = v.Inv;
		local x = v.x;
		local y = v.y;	
		local item = InventoryItems[inv][x][y];

		local icon = CreateModelIcon( item.IconModel, item.IconCamPos, item.IconLookAt, item.IconFov );
		icon:SetParent( AmmoMenu );
		icon:SetPos( 2, ( k - 1 ) * 50 + 2 );
		icon:SetSize( item.IconW, item.IconH );
		icon:SetAmbientLight( Color( 255, 255, 255, 255 ) );
		
		icon.Think = function()
		
			if( not InventoryItems[inv][x][y] ) then
			
				DestroyAmmoMenu();
				CreateAmmoMenu();
			
			end
		
		end
		
		icon.PaintHook = function()
		
			if( InventoryItems[inv][x][y] ) then
		
				if( InventoryItems[inv][x][y].Amt > 1 ) then
					draw.DrawText( InventoryItems[inv][x][y].Amt, "Default", item.IconW - 2, item.IconH - 15, Color( 255, 255, 255, 255 ), 2 );
				end
				
			end
			
		end
		
		icon.OnMousePressed = function( pnl, mc )
			
			if( LocalPlayer():Alive() ) then
				
				if( mc == MOUSE_LEFT ) then
				
					if( weap:GetTable().HeavyWeight ) then
				
						RunConsoleCommand( "eng_invheavyweap", inv, x, y );
						
					else
					
						RunConsoleCommand( "eng_invlightweap", inv, x, y );
					
					end
				
				end
				
			end
			
		end
	
	end		
	
	gui.EnableScreenClicker( true );

end

function DestroyAmmoMenu()

	if( AmmoMenu and AmmoMenu:IsValid() ) then
	
		AmmoMenu:Remove();
	
	end
	
	AmmoMenu = nil;
	
	HideMouse();

end

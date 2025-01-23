
WeaponTabsList = { }

WeaponsTabs = { }
WeaponsTabs[1] = { }
WeaponsTabs[2] = { }
WeaponsTabs[3] = { }

WeaponsMenuVisible = false;
WeaponsMenuFadeTime = 0;
WeaponsMenuFadeAlpha = 0;
SelectedTab = 3;
SelectedSlot = 1;

function AddWeaponFromList( index )

	local list = LocalPlayer():GetWeapons();
	
	if( list[index] and list[index] ) then

		local slot = list[index].Slot;
		local name = list[index]:GetPrintName();
		local desc = list[index].TS2Desc;
		
		if( not slot or slot > 3 or slot < 1 ) then 
			slot = 3;
		end
		
		table.insert( WeaponsTabs[slot], { PrintName = name, Desc = desc, Class = list[index]:GetClass() } );
		table.insert( WeaponTabsList, list[index]:GetClass() );
		
		
	end

end

function FillWeaponTabs()

	local list = LocalPlayer():GetWeapons();
	local classlist = { }
	
	for k, v in pairs( list ) do
	
		if( not table.HasValue( WeaponTabsList, v:GetClass() ) ) then
		
			AddWeaponFromList( k );
			
		end
		
		table.insert( classlist, v:GetClass() );
	
	end
	
	for k, v in pairs( WeaponTabsList ) do
	
		if( not table.HasValue( classlist, v ) ) then
		
			WeaponTabsList[k] = nil;
			
			for n, m in pairs( WeaponsTabs ) do
			
				for o, p in pairs( m ) do
				
					if( p.Class == v ) then
					
						WeaponsTabs[n][o] = nil;
					
					end
				
				end
			
			end
		
		end
	
	end
	
end

function GetWeaponSlotCount( slot )

	local n = 0;

	for k, v in pairs( WeaponsTabs[slot] ) do
		n = n + 1;
	end
	
	return n;

end

function GetMaxWeaponSlotIndex( slot )

	local n = 0;

	for k, v in pairs( WeaponsTabs[slot] ) do
		if( k > n ) then
			n = k;
		end
	end
	
	return n;

end

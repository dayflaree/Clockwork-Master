local meta = FindMetaTable( "Player" );

GM.MetaItems = { };

GM.PossibleStackVars = {
	"Caps",
	"Ammo",
	"Uses",
};

GM.TraderMenuBlacklist = {
	"caps",
	"bunker_keycard",
};

local files = file.Find( GM.FolderName .. "/gamemode/items/*.lua", "LUA", "namedesc" );

if( #files > 0 ) then
	
	for _, v in pairs( files ) do
		
		ITEM = { };
		ITEM.Vars = { };
		
		ITEM.Name = "Item";
		ITEM.Desc = "Description";
		ITEM.Model = "models/kleiner.mdl";
		ITEM.W = 1;
		ITEM.H = 1;
		
		ITEM.PrimaryWep = false;
		ITEM.SecondaryWep = false;
		
		if( SERVER ) then
			
			AddCSLuaFile( "items/" .. v );
			
		end
		
		include( "items/" .. v );
		
		ITEM.Class = string.StripExtension( v );
		
		GM.MetaItems[string.StripExtension( v )] = ITEM;
		
	end
	
end

function GM:PostGamemodeLoaded()

	for _, v in pairs( weapons.GetList() ) do
		
		if( string.find( v.ClassName, "weapon_inf" ) and ( v.PrimaryWep or v.SecondaryWep ) ) then
			
			ITEM = { };
			ITEM.Vars = { };
			
			if( v.Primary.ClipSize > -1 ) then
				
				ITEM.Vars.Clip = 0;
				
			end
			
			ITEM.Name = v.PrintName;
			ITEM.Desc = v.Description or "";
			ITEM.Model = v.WorldModel;
			ITEM.BasePrice = v.BasePrice or 999;
			ITEM.Category = v.ItemCategory;
			ITEM.W = v.W or 1;
			ITEM.H = v.H or 1;
			
			if( v.PrimaryWep ) then
				
				ITEM.Tier = 4;
				
			else
				
				ITEM.Tier = 3;
				
			end
			
			ITEM.PrimaryWep = v.PrimaryWep;
			ITEM.SecondaryWep = v.SecondaryWep;
			
			ITEM.ItemAmmo = v.ItemAmmo;
			
			if( v.Description ) then
				
				ITEM.GetDesc = function( self, item )
					
					local metaitem = GAMEMODE:GetMetaItem( item.Class );
					
					if( item.Vars.Clip ) then
						
						local ammotype = "9mm";
						
						if( v.ItemAmmo == "ammo_buckshot" ) then
							
							ammotype = "buckshot";
							
						elseif( v.ItemAmmo == "ammo_556mm" ) then
							
							ammotype = "5.56mm";
							
						elseif( v.ItemAmmo == "ammo_308" ) then
						
							ammotype = ".308";
							
						elseif( v.ItemAmmo == "ammo_45acp" ) then
						
							ammotype = ".45 ACP";
							
						elseif( v.ItemAmmo == "ammo_10mm" ) then
						
							ammotype = "10mm";
							
						elseif( v.ItemAmmo == "ammo_127mm" ) then
						
							ammotype = "12.7mm";
							
						elseif( v.ItemAmmo == "ammo_5mm" ) then
						
							ammotype = "5mm";
							
						elseif( v.ItemAmmo == "ammo_44" ) then
						
							ammotype = ".44 Magnum";
							
						elseif( v.ItemAmmo == "ammo_357" ) then
						
							ammotype = ".357 Magnum";
							
						elseif( v.ItemAmmo == "ammo_22lr" ) then
						
							ammotype = ".22 Long Rifle";
							
						end
						
						return metaitem.Desc .. "\n\nThere are " .. item.Vars.Clip .. " " .. ammotype .. " rounds loaded.";
						
					else
						
						return metaitem.Desc;
						
					end
					
				end
				
			else
				
				ITEM.GetDesc = function( self, item )
					
					if( item.Vars.Clip ) then
						
						local ammotype = "9mm";
						
						if( v.ItemAmmo == "ammo_buckshot" ) then
							
							ammotype = "buckshot";
							
						elseif( v.ItemAmmo == "ammo_556mm" ) then
							
							ammotype = "5.56mm";
							
						end
						
						return "There are " .. item.Vars.Clip .. " " .. ammotype .. " rounds loaded.";
						
					else
						
						return "";
						
					end
					
				end
				
			end
			
			ITEM.CamPos = v.CamPos;
			ITEM.FOV = v.FOV;
			ITEM.LookAt = v.LookAt;
			
			ITEM.Class = v.ClassName;
			
			GAMEMODE.MetaItems[v.ClassName] = ITEM;
			
		end
		
	end
	
end

function GM:GetMetaItem( class )
	
	return self.MetaItems[class];
	
end

function GM:Item( class )
	
	local tab = { };
	tab.Class = class;
	tab.Vars = table.Copy( self:GetMetaItem( class ).Vars or { } ); -- initialize default variables
	tab.Primary = false;
	tab.Secondary = false;
	tab.Clothing = self:GetMetaItem( class ).Clothing or nil;
	tab.Headgear = self:GetMetaItem( class ).Headgear or nil;
	tab.Equipped = false;
	
	return tab;
	
end

function GM:GetItemByTier( tier )
	
	local tab = { };
	
	for k, v in pairs( self.MetaItems ) do
		
		if( v.Tier == tier ) then
			
			tab[k] = v;
			
		end
		
	end
	
	if( tab != { } ) then
		
		return table.Random( tab ).Class;
		
	end
	
end

function meta:CheckInventory()
	
	if( self:CharID() == -1 ) then return true end
	
	if( !self.Inventory ) then
		
		self.Inventory = { };
		
	end
	
	return false;
	
end

function meta:IsInventorySlotOccupiedItem( i, j, w, h )
	
	if( self:CheckInventory() ) then return end
	
	if( i + w - 1 <= 6 and j + h - 1 <= 10 ) then -- if the item could potentially fit here
		
		local good = true;
		
		for x = 1, w do -- for each cell of the width of the item
			
			for y = 1, h do
				
				if( self:IsInventorySlotOccupied( i + x - 1, j + y - 1 ) ) then
					
					good = false;
					
				end
				
			end
			
		end
		
		return !good;
		
	end
	
	return true;
	
end

function meta:IsInventorySlotOccupiedItemFilter( i, j, w, h, key )
	
	if( self:CheckInventory() ) then return end
	
	if( i + w - 1 <= 6 and j + h - 1 <= 10 ) then -- if the item could potentially fit here
		
		local good = true;
		
		for x = 1, w do -- for each cell of the width of the item
			
			for y = 1, h do
				
				if( self:IsInventorySlotOccupied( i + x - 1, j + y - 1, key ) ) then
				
					good = false;
					
				end
				
			end
			
		end
		
		return !good;
		
	end
	
	return true;
	
end

function meta:IsInventorySlotOccupied( x, y, key )
	
	if( self:CheckInventory() ) then return end
	
	for _, v in pairs( self.Inventory ) do
		
		if( x >= v.X and x <= v.X + GAMEMODE:GetMetaItem( v.Class ).W - 1 ) then
			
			if( y >= v.Y and y <= v.Y + GAMEMODE:GetMetaItem( v.Class ).H - 1 ) then
				
				if( key and v.Key == key ) then return false end
				return true;
				
			end
			
		end
		
	end
	
	return false;
	
end

function meta:GetNextAvailableSlot( w, h )
	
	if( self:CheckInventory() ) then return end
	
	for j = 1, 10 do -- For each inventory slot (i, j)
		
		for i = 1, 6 do
			
			if( !self:IsInventorySlotOccupiedItem( i, j, w, h ) ) then
				
				return i, j;
				
			end
			
		end
		
	end
	
	return -1, -1;
	
end

function meta:GetItemsOfType( t )
	
	if( self:CheckInventory() ) then return end
	
	local keys = { };
	
	for k, v in pairs( self.Inventory ) do
		
		if( v.Class == t ) then
			
			table.insert( keys, k );
			
		end
		
	end
	
	return keys;
	
end

function meta:SaveWeaponClips()
	
	if( self:CheckInventory() ) then return end
	
	for k, v in pairs( self.Inventory ) do
		
		if( v.Vars.Clip ) then
			
			self:UpdateItemVars( k );
			
		end
		
	end
	
end

function meta:SaveWeaponVars( class )
	
	if( self:CheckInventory() ) then return end
	
	local key, item;
	local wep = self:GetWeapon( class );
	
	for k, v in pairs( self.Inventory ) do
		
		if( v.Class == class ) then
			
			key = k;
			item = v;
			break;
			
		end
		
	end
	
	if( item and item.Vars.Clip ) then
		
		item.Vars.Clip = wep:Clip1();
		
	end
	
end
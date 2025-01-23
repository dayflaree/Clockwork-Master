
--[[

-- Item flags --

a - Classifies item as ammo
d - Allows "drink" command
e - Allows "eat" command
i - Inventory-addon
p - Cannot put this item into your inventory
r - Radio
s - Stationary; Cannot pick up.
u - Allows "use" command
w - Classifies item as weapon
x - Allows "examine" command
# - Reserved flag, do not use

]]--

ItemsData = { }

ItemFactoryCount = 0;

function LoadWeaponsToItems()

	local weaps = weapons.GetList();
	local tab = { };
	
	for _, v in pairs( weaps ) do
		
		if( string.sub( v.ClassName, 1, 3 ) == "ep_" ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	for k, v in pairs( tab ) do
	
		ITEM = nil; 
		ITEM = { }; 
		ITEM.ID = v.ClassName; 
		ITEM.IsWeapon = true;
		if( v.Melee ) then
			ITEM.Flags = "vx";
		else
			ITEM.Flags = "wx";
		end
		ITEM.UseDelay = 1; 
		ITEM.PickupDelay = .1; 
		ITEM.Name = v.PrintName or ""; 
		ITEM.Description = v.EpiDesc; 
		ITEM.Model = v.ItemModel or v.WorldModel or ""; 
		ITEM.CamPos = v.IconCamPos or Vector( 0, 0, 0 ); 
		ITEM.LookAt = v.IconLookAt or Vector( 0, 0, 0 ); 
		ITEM.FOV = v.IconFOV or 90; 
		ITEM.Width = v.ItemWidth or 1; 
		ITEM.Height = v.ItemHeight or 1;
		ITEM.NicePhrase = v.NicePhrase or "a gun";
		ITEM.Tier = v.Tier or 0;
		ITEM.HealthAmt = 100;
		ITEM.WeaponData = v;
		
		if( v.LightWeight ) then
		
			ITEM.LightWeight = true;
			ITEM.HeavyWeight = false;
		
		else

			ITEM.LightWeight = false;
			ITEM.HeavyWeight = true;
		
		end
	
		ITEM.Pickup = function( self )		
			
			--self.Owner:Give( self.ID );		
		
		end		
	
		ITEM.Drop = function( self ) 
				
		end		
		
		ITEM.Examine = function( self )
			
			local num = math.random( 1, 2 );
			
			if( v.Melee ) then
				
				num = 2;
				
			end
			
			if( num == 1 ) then
				
				self.Owner:NoticePlainWhite( "Takes" .. v.Primary.AmmoString .. "." );
			
			else
				
				if( self.HealthAmt <= 5 ) then
					
					self.Owner:NoticePlainWhite( "Totally broken." );
					
				elseif( self.HealthAmt <= 20 ) then
					
					local str = v.Melee and "break" or "jam";
					self.Owner:NoticePlainWhite( "Probably going to " .. str .. " soon." );
					
				elseif( self.HealthAmt <= 40 ) then
					
					self.Owner:NoticePlainWhite( "It's seen better days." );
					
				elseif( self.HealthAmt <= 60 ) then
					
					self.Owner:NoticePlainWhite( "Obviously been used before." );
					
				elseif( self.HealthAmt <= 80 ) then
					
					self.Owner:NoticePlainWhite( "Fairly good condition - barely been used before." );
					
				else
					
					local str = v.Melee and "breaking" or "jamming";
					self.Owner:NoticePlainWhite( "It's in pristine condition. Not " .. str .. " anytime soon." );
					
				end
				
			end
		
		end
	
		ITEM = CleanItem( ITEM );
	
		ItemsData[ITEM.ID] = ITEM;		
	
	end


end

function LoadItemScript( file )

	ITEM = { }

	include( file );
	
	local id = string.gsub( file, ".lua", "" );
	
	ITEM.ID = id;
	
	ITEM = CleanItem( ITEM );

	ItemsData[id] = ITEM;

end

function CleanItem( data )

	data.Name = data.Name or "";
	data.Width = data.Width or 1;
	data.Height = data.Height or 1;
	data.Model = data.Model or "";
	data.Description = data.Description or "";
	data.NicePhrase = data.NicePhrase or "";
	data.Flags = data.Flags or "";
	data.Amount = data.Amount or 1;
	data.AddsOn = data.AddsOn or false;
	data.Repair = data.Repair or false;
	data.AddOnMax = data.AddOnMax or 1;
	data.CanCombineWith = data.CanCombineWith or { };
	data.AmmoCurrentClip = data.AmmoCurrentClip or 0;
	data.InventoryUse = data.InventoryUse or false;
	
	data.UseDelay = 1;
	data.PickupDelay = .5;
	
	data.CamPos = data.CamPos or Vector( 0, 0, 0 );
	data.LookAt = data.LookAt or Vector( 0, 0, 0 );
	data.FOV = data.FOV or 90;
	
	data.Use = data.Use or function() end;
	data.Pickup = data.Pickup or function() end;
	data.Drop = data.Drop or function() end;
	data.Examine = data.Examine or function() end;
	
	return data;
	
end

local tbl = file.FindInLua( "Epidemic/gamemode/items/*" );

for k, v in pairs( tbl ) do

	if( string.find( v, ".lua" ) and v ~= "items.lua" ) then

		LoadItemScript( v );
	
	end
	
end



function CreateItemProp( data )

	if( type( data ) == "string" ) then
	
		data = ItemsData[data];
	
	end
	
	if( not data ) then return; end
	
	ItemFactoryCount = ItemFactoryCount + 1;

	local item = ents.Create( "epd_item" );
	
	data.InInventory = false;
	
	item:AttachItem( data );
	item:SetModel( data.Model );
	item:SetSkin( data.Skin or 0 );
	
	item:GetTable().IFID = ItemFactoryCount;
	
	return item;	

end

function CallItemFunc( id, owner, func )

	local data = { };
	
	for k, v in pairs( ItemsData[id] ) do
	
		data[k] = ItemsData[id][k];
	
	end
	
	data.Owner = owner;
	
	data[func]( data );

end

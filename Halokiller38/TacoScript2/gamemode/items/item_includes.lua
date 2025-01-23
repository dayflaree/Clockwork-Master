
--ITEM FLAGS--
--Quick ref!--
-- e - edible
-- d - drinkable
-- p - paper item / can write on
-- l - letter item / can read
-- u - can use
-- c - Is a container
-- ! - can not put in inventory
-- s - Item can only be placed in storage like briefcases or backpacks
-- C - Is a container, but not storage (you cannot put things into it, only take out). Can put in inventory.
-- W - Wearable.  Can contain its own inventory.
-- w - Weapon.  Don't use this. 
-- @ - Can use some of this item.
-- t - Tuneable (RADIO ONLY).

function TS.HandleItemSpawning( DATA )

	if( not type( DATA ) == "table" ) then
	
		return;
		
	end
	
	if( not TS.ProcessedItems ) then
	
		TS.ProcessedItems = { }
		
	end
	
	local bi = { 
	
		"clothes_storage",
		"clothes_citizen",
		"clothes_rebel",
		"clothes_rebelmedic",
		"ccadevice",
	
	}
	
	if( not table.HasValue( bi, DATA.ID ) ) then
	
		table.insert( TS.ProcessedItems, DATA );
	
	end
	
	DATA = nil;

end

function TS.IncludeItem( dir )
	
	ITEM = nil;
	ITEM = { }

	include( dir );
	
	local id = string.gsub( dir, ".lua", "" );
	
	ITEM.ID = id;
	ITEM.Flags = ITEM.Flags or "";
	ITEM.UseDelay = ITEM.UseDelay or 1;
	ITEM.PickupDelay = ITEM.PickupDelay or .7;
	ITEM.Amount = ITEM.Amount or 1;
	ITEM.Price = ITEM.Price or 1;
	
	ITEM.Drop = ITEM.Drop or function() end
	ITEM.Use = ITEM.Use or function() end
	
	ITEM.IsContainer = function( self )
	
		if( string.find( self.Flags, "c" ) or
			string.find( self.Flags, "C" ) or
			string.find( self.Flags, "W" ) ) then

			return true;

		end
		
		return false;
	
	end
	
	ITEM.CanDrop = function( self )
	
		return true;
	
	end

	TS.ItemsData[id] = ITEM;
	
	TS.HandleItemSpawning( ITEM );

end

local list = file.FindInLua( "TacoScript2/gamemode/items/*.lua" );

for k, v in pairs( list ) do

	if( v ~= "item_includes.lua" and
		v ~= "item_interaction.lua" ) then
		
		TS.IncludeItem( v );
		
	end

end

TS.FormatedWeaponsToItems = false;
TS.WeaponGivingDelay = true;

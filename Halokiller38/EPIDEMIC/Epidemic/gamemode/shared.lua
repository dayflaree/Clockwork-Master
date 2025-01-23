if( SERVER ) then
	AddCSLuaFile( "sh_animations.lua" );
	AddCSLuaFile( "anim_tables.lua" );
end
include( "sh_animations.lua" );
include( "anim_tables.lua" );

MAX_INVENTORIES = 11; --How many inventories the player can have.  You can cautiously up this.  But beware of performance issues if this goes too high.
MAX_INV_WIDTH = 6; --Max slots an inventory can have horizontally
MAX_INV_HEIGHT = 6; --Max slots an inventory can have vertically


--Used by server side and client side to verify the character create fields are good.
function CharacterCreateValidFields( ply, name, age, desc, model )
	
	if( string.find( string.lower( model ), "infected/necropolis" ) ) then
		
		if( string.len( name ) < 3 ) then 
		
			return false, "Name too short";
		
		end
		
	else
		
		if( string.len( name ) < 7 ) then 
		
			return false, "Name too short";
		
		end
		
	end
	
	if( string.len( name ) > 35 ) then
	
		return false, "Name too long";
	
	end
	
	if( CLIENT ) then
	
		if( OpeningScreen.CharacterSaves ) then

			local tbl = { }
			
			for k, v in pairs( OpeningScreen.CharacterSaves ) do
			
				table.insert( tbl, v );
			
			end
			
			table.insert( tbl, LocalPlayer():GetNWString( "RPName" ) );
			
			for k, v in pairs( tbl ) do
			
				if( string.gsub( string.lower( v ), " ", "" ) == string.gsub( string.lower( name ), " ", "" ) ) then
					
					return false, "You already created this character";
					
				end
				
			end
			
		end
	
	end
	
	if( SERVER ) then
	
		if( ply:sqlCharacterWithNameExists( name ) ) then
		
			return false;
		
		end
	
	end
	
	if( not tonumber( age ) ) then
	
		return false, "Age not valid";
	
	end
	
	if( tonumber( age ) < 16 ) then
	
		return false, "Age cannot be under 16";
	
	end
	
	if( tonumber( age ) > 67 ) then
	
		return false, "Age cannot be over 67";
	
	end
	
	if( string.len( string.gsub( desc, " ", "" ) ) < 10 ) then
	
		return false, "Physical Description must be 10 characters or over";
	
	end
	
	if( string.len( desc ) > 120 ) then
	
		return false, "Physical Description must be under 120 characters";
	
	end
	
	local playerflags = "";
	
	if( SERVER ) then
	
		playerflags = ply:GetPlayerFlags();
	
	else
	
		playerflags = ClientVars["Flags"];
	
	end
	
	for k, v in pairs( PlayerGroups ) do

		if( v.Default or string.find( playerflags or "", v.FlagsRequired or "" ) ) then
		
			if( table.HasValue( v.Models, string.lower( model ) ) ) then
				
				return true;
			
			end
		
		end
	
	end
	
	return false, "Invalid model";

end

CurrentMap = nil;

function GetMap()
	
	if( !CurrentMap ) then
		
		CurrentMap = game.GetMap();
		
	end
	
	if( CurrentMap == "rp_necro_torrington" ) then
		
		CurrentMap = "rp_necro_torrington_day";
		
	end
	
	return CurrentMap;

end

if( not InitializedOnce ) then

	function GM:ShouldCollide( ent1, ent2 )
		
		if( ent1 and ent2 and ent1:IsValid() and ent2:IsValid() ) then
			
			local ent1class = ent1:GetClass();
			local ent2class = ent2:GetClass();
			
			if( ent1class == "ep_commonzombie" and
				ent2class == "ep_commonzombie" ) then
				
				return false;
				
			end
			
			if( ent1:GetNWInt( "ZombiDoor", 0 ) == 1 and
				ent2:GetClass() == "ep_commonzombie" ) then
				
				return false;
				
			end
			
			if( ent2:GetNWInt( "ZombiDoor", 0 ) == 1 and
				ent1:GetClass() == "ep_commonzombie" ) then
				
				return false;
				
			end
			
		end
		
		return true;
	
	end
	
end

SMOKE_EFFECTS = {
	"weapon_muzzle_smoke",
	"weapon_muzzle_smoke_b",
	"weapon_muzzle_smoke_b Version #2",
	"weapon_muzzle_smoke_long",
	"weapon_muzzle_smoke_long_b",
}

for _, v in pairs( SMOKE_EFFECTS ) do
	
	PrecacheParticleSystem( v );
	
end

local meta = FindMetaTable( "Entity" );

local DoorTypes = { }

DoorTypes["func_door"] = true;
DoorTypes["func_door_rotating"] = true;
DoorTypes["prop_door_rotating"] = true;

function meta:IsDoor()

	if( DoorTypes[self:GetClass()] ) then
		return true;
	end
	
	return false;

end

function meta:ModelStr( str )
	
	if( string.find( string.lower( self:GetModel() ), string.lower( str ) ) ) then
		
		return true;
		
	end
	
	return false;
	
end

function meta:ModelTab( tab )
	
	for _, v in pairs( tab ) do
		
		if( string.find( string.lower( self:GetModel() ), string.lower( v ) ) ) then
			
			return true;
			
		end
		
	end
	
	return false;
	
end

function meta:GetEpiViewOffset()
	
	return 64;
	
end

function meta:GetEpiCrouchViewOffset()
	
	return 28;
	
end

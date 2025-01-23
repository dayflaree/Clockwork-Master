

local meta = FindMetaTable( "Player" );

local RentOptions = 
{

	{ Length = 1, Price = 1 },
	
}

function TS.GetOptionDoorPrice( id, door )

	if( id == -1 ) then
		return 0;
	else
		return math.ceil( RentOptions[id].Price * door.DoorPrice );
	end
	--return math.ceil( RentOptions[2].Price * door.DoorPrice );

end

function meta:CanOwnDoor( door )

	if( door.DoorPrice ) then
	
		if( door.DoorFlags ) then
		
			if( self:IsCitizen() ) then
			
				if( string.find( door.DoorFlags, "c" ) ) then
					
					return true;
				
				end
			
			elseif( self:IsCP() ) then
				
				if( string.find( door.DoorFlags, "C" ) ) then
				
					return true;
				
				end			
				
			end
		
		end
	
	end
	
	return false;

end

function meta:UnownallDoors()

	if( not self.Owned ) then return; end

	for k, v in pairs( self.Owned ) do
	
		v:UnownDoor( self );
	
	end

end

function meta:OwnProperty( door, id )

	local price = TS.GetOptionDoorPrice( id, door );
	self:PrintMessage( 2, "Own Property" );
	if( not self:CanAfford( price ) ) then
	
		self:PrintMessage( 3, "You cannot afford this." );
		return;
	
	end
	
	self:SubeMoney( price );
	self:OwnDoor( door );

	local parent = door.PropertyParent;
	
	for k, v in pairs( TS.MapDoors ) do
	
		if( v.PropertyParent == parent and v.PropertyParent ~= 7 ) then
		--if( v.PropertyParent == child ) then
		
			if( not v.Door:OwnsDoor( self ) ) then
					self:OwnDoor( v.Door );
			end
			
		end
	
	end

end

function meta:OwnDoor( door ) 
	if( door.MainOwner == nil ) then
		door.MainOwner = self;
		door.MainOwnerSteamID = self:SteamID();
		door:SetNWInt( "Owned", 1 );
	else
		if( door.Owners == nil ) then door.Owners = { }; end
		if( door.OwnersBySteamID == nil ) then door.OwnersBySteamID = { }; end
		 
		door.OwnersBySteamID[#door.Owners + 1] = self:SteamID();
		door.Owners[#door.Owners + 1] = self;	
		
	end					
	
end

local meta = FindMetaTable( "Entity" );

function meta:GetDoorOwnersList()

	local tbl = { }
	
	for k, v in pairs( self.Owners ) do
	
		table.insert( tbl, v );
	
	end
	
	table.insert( tbl, self.MainOwner );
	
	return tbl;

end

function meta:UnownProperty( ply )

	local parent = self.PropertyParent;
	
	--self:UnownDoor( ply );
	
	for k, v in pairs( TS.MapDoors ) do
	
		if( v.PropertyParent == parent ) then
		
			if( v.Door:OwnsDoor( ply ) ) then
				v.Door:UnownDoor( ply );
			end
			
			
		end
	
	end

end

function meta:UnownDoor( ply )

	if( self.MainOwner == ply ) then
	
		self.MainOwner = nil;
		self.MainOwnerSteamID = nil;
		
		if( self.DoorPrice == 0 ) then
					ply.OwnsFreeProperty = false;
		end
		
		self:SetNWInt( "Owned", 0 );
	
	else
	
		if( self.Owners == nil ) then self.Owners = { }; end
		if( self.OwnersBySteamID == nil ) then self.OwnersBySteamID = { }; end
		
		for k, v in pairs( self.Owners ) do
		
			if( v == ply ) then
			
				self.Owners[k] = nil;
				self.OwnersBySteamID[k] = nil;
				return;
			
			end
		
		end
	
	end
						

end

function meta:HasNoOwners()

	if( self.MainOwner == nil ) then
	
		if( self.Owners == nil ) then return true; end
	
		local nvalid = 0;
		
		for k, v in pairs( self.Owners ) do
		
			if( v:IsValid() ) then
			
				nvalid = nvalid + 1;
			
			end
		
		end
		
		if( nvalid == 0 ) then return true; end
	
	end

	return false;

end

function meta:OwnsDoor( ply )

	if( ply:IsCP() ) then			
		if( string.find( self.DoorFlags, "o" ) ) then			
			return true;		
		end		
	end

	if( self.MainOwner == ply ) then
		
		return true;
		
	else
		
		if( self.Owners == nil ) then self.Owners = { }; end
	
		for k, v in pairs( self.Owners ) do
			
			if( v == ply ) then
				
				return true;
					
			end
			
		end
		
	end	
	
	return false;

end

--  not really to do with door ownership

function meta:SplodeDoor()

	if( self:IsDoor() ) then

		local pos = self:GetPos();
		local ang = self:GetAngles();
		local model = self:GetModel();
		local skin = self:GetSkin();

		local exp = ents.Create( "env_explosion" );
		exp:SetKeyValue( "spawnflags", 128 );
		exp:SetPos( pos );
		exp:Spawn();
		exp:Fire( "explode", "", 0 );
		
		local exp = ents.Create( "env_physexplosion" );
		exp:SetKeyValue( "magnitude", 150 );
		exp:SetPos( pos );
		exp:Spawn();
		exp:Fire( "explode", "", 0 );
			
		timer.Simple( 1.0, exp.Remove, exp );
		
		self:BreakDoor();
	
	else
	
		return false;
	
	end
		
end

function meta:BreakDoor()

	if( self:IsDoor() ) then

		local pos = self:GetPos();
		local ang = self:GetAngles();
		local model = self:GetModel();
		local skin = self:GetSkin();

		self:SetNotSolid( true );
		self:SetNoDraw( true );
		self:Fire( "open", "", 0 );
					
		local function ResetDoor( door, fakedoor )
			door:SetNotSolid( false );
			door:SetNoDraw( false );
			door.BoobyTrapped = false;
			fakedoor:Remove();
		end			

		local ent = ents.Create( "prop_physics" );
		ent:SetPos( pos );
			ent:SetAngles( ang );
			ent:SetModel( model );
			if( skin ) then
				ent:SetSkin( skin );
			end
		ent:Spawn();
												
		timer.Simple( 300, ResetDoor, self, ent );
		
	else
	
		return false;
	
	end

end

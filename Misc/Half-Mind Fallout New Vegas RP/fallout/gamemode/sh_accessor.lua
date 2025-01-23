local accessors = { };
accessors["Player"] = {
	{ "CharID", "Float", -1 },
	{ "RPName", "String", "..." },
	{ "Desc", "String", "" },
	{ "Sex", "Float", 1 },
	{ "Face", "String", "" },
	{ "Facemap", "String", "" },
	{ "Eyemap", "String", "" },
	{ "Hair", "String", "" },
	{ "HairColor", "String", "0 0 0" },
	{ "FacialHair", "String", "" },
	{ "Holstered", "Bool", true },
	{ "IsTrader", "Bool", false },
	{ "TraderFlags", "String", "" },
	{ "Typing", "Float", 0 },
	{ "Admin", "Bool", false },
	{ "SuperAdmin", "Bool", false },
	{ "PhysTrust", "Bool", true },
	{ "ToolTrust", "Bool", true },
	{ "HasPAC", "Bool", false },
	{ "CharCreateFlags", "String", "" },
	{ "PlayerClass", "Float", PLAYERCLASS_SURVIVOR },
	{ "PlayerTitle", "String", "" },
	{ "PlayerTitleColor", "String", "255 255 255" },
	{ "PrimaryWeaponModel", "String", "" },
	{ "SecondaryWeaponModel", "String", "" },
	{ "LastPos", "String", "0 0 0" },
	{ "RadioFreq", "Float", "100.1" },
};
accessors["Entity"] = {
	{ "DoorHealth", "Float", 100 },
}

for k, v in pairs( accessors ) do
	
	local meta = FindMetaTable( k );
	
	for m, n in pairs( v ) do
		
		local name = n[1];
		local type = n[2];
		local default = n[3];
		local private = n[4] or false;
		
		meta[name] = function( self )
			
			if( self["_accessor_" .. name] != nil ) then
				
				return self["_accessor_" .. name];
				
			else
				
				return default;
				
			end
			
		end
		
		meta["Set" .. name] = function( self, val, shared )
			
			self["_accessor_" .. name] = val;
			
			GAMEMODE:OnAccessorChanged( name, val );
			
			if( SERVER and !shared ) then
				
				if( private ) then
					
					if( self:IsBot() ) then return end
					
					net.Start( "nSetAccessorP" .. name );
						net["Write" .. type]( val );
					net.Send( self );
					
				else
					
					net.Start( "nSetAccessor" .. name );
						net.WriteEntity( self );
						net["Write" .. type]( val );
					net.Broadcast();
					
				end
				
			end
			
		end
		
		if( SERVER ) then
			
			util.AddNetworkString( "nSetAccessorP" .. name );
			util.AddNetworkString( "nSetAccessor" .. name );
			
		else
			
			local function nSetAccessorP( len )
				
				local val = net["Read" .. type]();
				LocalPlayer()["Set" .. name]( LocalPlayer(), val );
				
			end
			net.Receive( "nSetAccessorP" .. name, nSetAccessorP );
			
			local function nSetAccessor( len )
				
				local ply = net.ReadEntity();
				local val = net["Read" .. type]();
				
				if( ply and ply:IsValid() ) then
					
					ply["Set" .. name]( ply, val );
					
				end
				
			end
			net.Receive( "nSetAccessor" .. name, nSetAccessor );
			
		end
		
	end
	
end

local meta = FindMetaTable( "Player" );

if( SERVER ) then
	
	function meta:SyncPlayer( ply )
		
		for _, n in pairs( accessors["Player"] ) do
			
			if( !n[4] ) then
				
				net.Start( "nSetAccessor" .. n[1] );
					net.WriteEntity( ply );
					net["Write" .. n[2]]( ply[n[1]]( ply ) );
				net.Send( self );
				
			end
			
		end
		
		if( IsValid( ply ) ) then
		
			if( ply:CharID() > -1 and ply:PlayerClass() == PLAYERCLASS_SURVIVOR ) then
			
				local arms,skin = GAMEMODE:GetModelArms( ply:GetModel(), ply:Face() );
				
				/*net.Start("nCharacterRemoveAllMdl"); -- this is called when there shouldnt be any csentities present, but better safe than sorry.
					net.WriteEntity( ply );
				net.Send( self );
				
				net.Start("nCharacterInitModel"); -- this right here might actually cause some big freezes when first joining when there are large player numbers. should probably use a timer to space it out.
					net.WriteEntity( ply );
					net.WriteTable( {
						[ply:Face()] = ply:Facemap(),
						[ply:Hair()] = "",
						[ply:FacialHair()] = "",
						[arms] = skin,
					} );
				net.Send( self );*/
				
			end
		
		end
		
	end
	
	function meta:SyncOtherPlayers()
		
		for _, v in pairs( player.GetAll() ) do
			
			if( v != self ) then
				
				self:SyncPlayer( v );
				
			end
			
		end
		
	end
	
	local function nRequestPlayerData( len, ply )
		
		local targ = net.ReadEntity();
		ply:SyncPlayer( targ );
		ply:SyncOtherPlayers();
		
	end
	net.Receive( "nRequestPlayerData", nRequestPlayerData );
	
else
	
	function meta:RequestPlayerData()

		net.Start( "nRequestPlayerData" );
			net.WriteEntity( self );
		net.SendToServer();
		
	end
	
end

function GM:OnAccessorChanged( name, val )
	
	
	
end

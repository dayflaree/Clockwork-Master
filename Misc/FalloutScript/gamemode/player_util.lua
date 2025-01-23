-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- player_util.lua
-- Useful functions for players.
-------------------------------
-- Use these meta commands to change stuff like, warnings, rads, tested, etc...

function LEMON.SendChat( ply, msg )

	ply:PrintMessage( 3, msg );
	
end

function LEMON.SendConsole( ply, msg )

	ply:PrintMessage( 2, msg );
	
end

DecayingRagdolls = {};

function LEMON.DeathMode( ply )


	local mdl = ply:GetModel( )

	local rag = ents.Create( "prop_ragdoll" )
	rag:SetModel( mdl )
	rag:SetName( "plragdoll" ) --this name will be used to stop Tools or Physguns from messing with dead corpses
	rag:SetPos( ply:GetPos( ) )
	rag:SetAngles( ply:GetAngles( ) )
	rag.isdeathdoll = true;
	rag.ply = ply;
	rag:Spawn( )
	ply:SetViewEntity( OBS_MODE_DEATHCAM );
	ply.deathrag = rag;
	
	local n = #DecayingRagdolls + 1
	DecayingRagdolls[ n ] = ply.deathrag;
	
	ply:SetNWInt( "deathmode", 1 )
	ply:SetNWInt( "deadmoderemaining", 15 );
	
	ply.deathtime = 0;
	ply.nextsecond = CurTime( ) + 1;

    timer.Simple( 15, function()

    ply.deathtime = 120;
	ply.deathrag = nil;
	
	end )
	
	timer.Simple( LEMON.ConVars[ "ragremovaltime" ], function()
	
	rag:Remove()
	
	end )
	
	-- This is extremely glitchy with the physics engine, and is to be reworked later.
	
	local function Freeze( )
	local rag = DecayingRagdolls[ n ];

	if( rag and rag:IsValid() ) then
		
			FreezeRagdoll(rag)
	
	end

	end
-- Decay mode is inactive
	local function Decay1( )
	
		local rag = DecayingRagdolls[ n ];
		
		if( rag and rag:IsValid() ) then
		
			rag:SetModel( "models/player/corpse1.mdl" )
			
		end
		
	end
	
	local function Decay2( )

		local rag = DecayingRagdolls[ n ];
	
		if( rag and rag:IsValid() ) then
		
			rag:SetModel( "models/player/Charple01.mdl" )
		
		end

	end
	
	local function Decay3( )
	
		local rag = DecayingRagdolls[ n ];
		
		if( rag and rag:IsValid() ) then
		
			rag:Remove( );
			DecayingRagdolls[ n ] = nil;
			rag = nil;
			
		end
		
	end
	timer.Simple( 10, Freeze );
	timer.Simple( 3600, Decay3 );
end

local meta = FindMetaTable( "Player" );

function meta:IsInDoorGroup( entity )

		
        if( LEMON.IsDoor( entity ) ) then

        local pos = entity:GetPos( );
		
		for k, v in pairs( LEMON.Doors ) do
		
			if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
			
				for k2, v2 in pairs( LEMON.Teams[ self:Team( ) ][ "door_groups" ] ) do
				
					if( tonumber( v[ "group" ] ) == tonumber( v2 ) ) then
					
						return true;
						
					end
					
				end
				
			end
			
		end

end
		return false;
end

function meta:HasFlag(flag)

	local flags = LEMON.GetCharField(self, "flags" );
 for k,v in pairs(flags) do
    if(table.HasValue(flags, flag)) then return true; end
    return false;
 end

end

function meta:HasItem(item)

	local inv = LEMON.GetCharField( self, "inventory" );

		if( table.HasValue(inv, item) ) then
			return true;
		end

	return false;

end

function meta:MaxHealth( )

	return self:GetNWFloat("MaxHealth");
	
end

function meta:ChangeMaxHealth( amt )

	self:SetNWFloat("MaxHealth", self:MaxHealth() + amt);
	
end

function meta:MaxArmor( )

	return self:GetNWFloat("MaxArmor");
	
end

function meta:ChangeMaxArmor( amt )

	self:SetNWFloat("MaxArmor", self:MaxArmor() + amt);
	
end

function meta:MaxWalkSpeed( )

	return self:GetNWFloat("MaxWalkSpeed");
	
end

function meta:ChangeMaxWalkSpeed( amt )

	self:SetNWFloat("MaxWalkSpeed", self:MaxWalkSpeed() + amt);
	
end

function meta:MaxRunSpeed( )

	return self:GetNWFloat("MaxRunSpeed");
	
end

function meta:ChangeMaxRunSpeed( amt )

	self:SetNWFloat("MaxRunSpeed", self:MaxRunSpeed() + amt);
	
end

function meta:GiveItem( class )

	local inv = LEMON.GetCharField( self, "inventory" );
	table.insert( inv, class );
	LEMON.SetCharField( self, "inventory", inv);
	self:RefreshInventory( );

end

function meta:TakeItem( class )
	local inv = LEMON.GetCharField(self, "inventory" );
	
	for k, v in pairs( inv ) do
		if( v == class ) then
			inv[ k ] = nil;
			LEMON.SetCharField( self, "inventory", inv);
			self:RefreshInventory( );
			return;
		end
	end
	
end

function meta:ClearInventory( )
	umsg.Start( "clearinventory", self )
	umsg.End( );
end

function meta:RefreshInventory( )
	self:ClearInventory( )
	
	for k, v in pairs( LEMON.GetCharField( self, "inventory" ) ) do
		umsg.PoolString( LEMON.ItemData[ v ].Class )
		umsg.PoolString( LEMON.ItemData[ v ].Name )
		umsg.PoolString( LEMON.ItemData[ v ].Model )
		umsg.PoolString( LEMON.ItemData[ v ].Description )
		umsg.PoolString( LEMON.ItemData[ v ].Weight )
		umsg.PoolString( LEMON.ItemData[ v ].Dist )
		umsg.PoolString( LEMON.ItemData[ v ].Damage )
		umsg.PoolString( LEMON.ItemData[ v ].DamageType )
		umsg.PoolString( LEMON.ItemData[ v ].AmmoType )
		umsg.PoolString( LEMON.ItemData[ v ].AmmoCapacity )
		umsg.Start( "addinventory", self );
			umsg.String( LEMON.ItemData[ v ].Class )
			umsg.String( LEMON.ItemData[ v ].Name )
			umsg.String( LEMON.ItemData[ v ].Model )
			umsg.String( LEMON.ItemData[ v ].Description )
			umsg.String( LEMON.ItemData[ v ].Weight )
			umsg.Float( LEMON.ItemData[ v ].Dist )
			umsg.String( LEMON.ItemData[ v ].Damage )
			umsg.String( LEMON.ItemData[ v ].DamageType )
			umsg.String( LEMON.ItemData[ v ].AmmoType )
			umsg.String( LEMON.ItemData[ v ].AmmoCapacity )
		umsg.End( );

	end
end

function meta:ClearBusiness( )
	umsg.Start( "clearbusiness", self )
	umsg.End( );
end





function meta:RefreshBusiness( )
	self:ClearBusiness( )
		
	if(LEMON.Teams[self:Team()] == nil) then return; end -- Team not assigned
	
	for k, v in pairs( LEMON.ItemData ) do
	
		if( v.Purchaseable and table.HasValue( LEMON.Teams[self:Team()]["item_groups"], v.ItemGroup ) ) then


			umsg.Start( "addbusiness", self );
				umsg.String( v.Class );
				umsg.String( v.Name );
				umsg.String( v.Model );
				umsg.String( v.Description );
				umsg.Long( v.Price );
			umsg.End( );
			
		end
	end
end

function meta:ChangeMoney( amount ) -- Modify someone's money amount.
	
	LEMON.SetCharField( self, "money", LEMON.GetCharField( self, "money" ) + amount );
	self:SetNWString( "money", LEMON.GetCharField( self, "money" ) );

end

function meta:ChangeWarning( amount )

	LEMON.SetPlayerField( self, "warnings", LEMON.GetPlayerField( self, "warnings" ) + amount )
	self:SetNWString( "warnings", LEMON.GetPlayerField( self, "warnings" ) )
	
end

function meta:ChangeRADS( amount )

	LEMON.SetCharField( self, "rads", LEMON.GetCharField( self, "rads" ) + amount )
	self:SetNWInt( "rads", LEMON.GetCharField( self, "rads" ) )
	if self:GetNWInt( "rads" ) > 1000 then
		self:SetNWBool( "radkiller", true )
		self:SetNWInt( "rads", 0 )
	end
	
end

function meta:Karma( amount )

	LEMON.SetPlayerField( self, "karma", LEMON.GetPlayerField( self, "warnings" ) + amount )
	self:SetNWInt( "karma", LEMON.GetPlayerField( self, "karma" ) )
	
end

function meta:Tested( amount )

	LEMON.SetPlayerField( self, "tested", LEMON.GetPlayerField( self, "tested" ) + amount )
	self:SetNWString( "tested", LEMON.GetPlayerField( self, "tested" ) )
	--print( self )

	
end

function LEMON.DrugPlayer( pl, mul ) 

	mul = mul / 10 * 2;

	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha " .. 0.05 * mul)
	pl:ConCommand("pp_motionblur_delay " .. 0.035 * mul)
	pl:ConCommand("pp_motionblur_drawalpha 1.00")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 8")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")

	timer.Create(IDSteam, 40 * mul, 1, LEMON.UnDrugPlayer, pl)
end

function LEMON.UnDrugPlayer(pl)
	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end

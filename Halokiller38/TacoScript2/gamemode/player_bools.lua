
local meta = FindMetaTable( "Player" );

local BannedTools =
{
	
	"ignite",
	"balloon",
	"dynamite",
	"emitter",
	"hover-ball",
	"lamp",
	"magnetise",
	"thruster",
	"paint",
	"wheel",
	"turret",
	"pulley",
	"muscle",
	"motor",
	
}

function meta:CanToolThis( ent, mode )


	if( ent:GetClass() == "ts2_attachment" or
		ent:GetClass() == "ts2_pickup" ) then
		
		return false;
		
	end
	
	if( ent:GetClass() == "ts2_item" ) then
	
		if( ent.PickupParent and ent.PickupParent:IsValid() ) then
		
			return false;
		
		end
	
	end
	
	if( ent:GetClass() == "prop_ragdoll" and ent.IsPlayerRagdoll ) then
	
		return false;
	
	end
	
	if( ent:GetClass() == "prop_dynamic_override" ) then
	
		return false;
	
	end

	--If Rick made this, only Rick can destroy this
	if( ent.CreatorIsRick and not self:IsRick() ) then
	
		return false;
	
	end

	--If the player is either an admin or Rick, true
	if( self:IsSuperAdmin() or self:IsRick() ) then
	
		return true;
	
	end
	
	if( self:IsAdmin() ) then
	
		if( ent:IsDoor() ) then

			return true;
	
		end
		
	end
	
	if( ent:GetClass() == "prop_vehicle_prisoner_pod" or string.find( ent:GetClass(), "npc" ) ) then
	
		if( string.find( string.lower( mode ), "remover" ) or string.find( string.lower( mode ), "weld" ) ) then

			return true;
			
		end
		
	end
	
	--Duplicator!
	if( string.find( string.lower( mode ), "duplicator" ) ) then
	
		if( not string.find( ent:GetClass(), "npc" ) ) then
	
			return true;
			
		end
		
	end
	
	--Better than adding each individual banned tool.
	for k, v in pairs( BannedTools ) do
	
		if( not self:IsSuperAdmin() or not self:IsRick() ) then
	
			if( string.find( string.lower( mode ), v ) ) then
		
				return false;
			
			end
			
		end
	
	end
	
	--No adv duplicator
	if( string.find( string.lower( mode ), "adv_duplicator" ) ) then
	
		return false;
	
	end
	
	--If the creator is tooling this, true
	if( ent.Creator == self ) then
	
		return true;
	
	end
	
	--If the player has advanced TT, and the creator isnt a super admin or Rick, return if it can phys gun pickup
	if( self:HasTT() and not ent.CreatorIsSuperAdmin and not ent.CreatorIsRick ) then
		
		return self:CanPhysGunPickup( ent );
		
	end
	
	--If it's an item and the player has TT and it's not duplicator, true
	if( ent:GetClass() == "ts2_item" and self:HasTT() and mode ~= "duplicator" ) then
		
		return true;
		
	end
	
	--If the player doesn't have any TT, return if he can physgun it
	if( not ent.CreatorHasTT ) then
	
		return self:CanPhysGunPickup( ent );
	
	end
	
	--If the creator had basic TT and the tooling player has TT
	if( ent.CreatorHasTT and self:HasTT() ) then
		
		return true;
		
	end
	
	return false;

end

local CantPhysGun =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating",
	"func_breakable",
	"func_brush",
	"func_tracktrain",
	"func_physbox",
	"player",
	"prop_vehicle_jeep",
	"func_breakable_surf",
	"prop_vehicle_jeep_old",
	"prop_vehicle_airboat",
	"func_movelinear",
	"prop_dynamic",
	"func_monitor",
	"prop_dynamic_override",

};

function meta:CanPhysGunPickup( ent )
	
	if( ( self:IsSuperAdmin() or self:IsRick() ) and ( ent:IsPlayer() or
		ent:GetClass() == "prop_vehicle_jeep" or
		ent:GetClass() == "prop_vehicle_jeep_old" or
		ent:GetClass() == "prop_vehicle_airboat" or 
		ent:GetClass() == "prop_ragdoll" ) ) then
	
		return true;
	
	end
	
	for k, v in pairs( CantPhysGun ) do
	
		if( ent:GetClass() == v ) then
			return false;
		end
	
	end
	
	return true;

end

function meta:HasTT()
	
	if( self:GetSQLData( "group_hastt" ) == 1 ) then

		return true;

	end
	
	return false;

end

function meta:CanUseAdminCommand() 

	if( not self.Initialized ) then
		return false;
	end

	if( self:IsRick() or 
		self:IsSuperAdmin() or
		self:IsAdmin() ) then
		
		return true;
		
	end
	
	return false;

end

function meta:CanUseSuperAdminCommand() 

	if( not self.Initialized ) then
		return false;
	end

	if( self:IsRick() or 
		self:IsSuperAdmin() ) then
		
		return true;
		
	end
	
	return false;

end

function meta:IsTied()

	return self.IsTied;

end

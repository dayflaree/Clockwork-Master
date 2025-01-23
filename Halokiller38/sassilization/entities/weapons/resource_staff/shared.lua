
// Variables that are used on both client and server


SWEP.Author		= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Spawn your farm and iron mine."

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true		// Spawnable in singleplayer or by server admins

SWEP.ViewModel			= "models/weapons/v_crossbow.mdl"
SWEP.WorldModel			= "models/weapons/w_crossbow.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

inSupply = false

function SWEP:Initialize()
	self.Weapon:SetNWBool( "check", false )
	self.Weapon:SetNWBool( "setup", false )
	self.node = ""
	self.model = ""
	self.holstered = false
end

function SWEP:Think()
	if self.holstered then return end

	if self.Weapon:GetNWBool( "check" ) then
		self.node = "iron_mine"
		self.model = "models/jaanus/ironmine.mdl"
	else
		self.node = "farm"
		self.model = "models/jaanus/farmpatch.mdl"
	end

	if self.Weapon:GetNWBool( "setup" ) then return end

 	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self.model ) then 
 		self:MakeGhostEntity( self.model, Vector(0,0,0), Angle(0,0,0) ) 
 	end

 	self:UpdateGhostButton( self.GhostEntity, self.Owner )
end

function SWEP:Holster()
	self.holstered = true
	self:ReleaseGhostEntity()
	return true
end

function SWEP:Deploy()
 	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self.model ) then 
 		self:MakeGhostEntity( self.model, Vector(0,0,0), Angle(0,0,0) ) 
 	end
	self.holstered = false
	return true
end

function SWEP:UpdateGhostButton( ent, player )

	if ( !ent ) then return end
 	if ( !ent:IsValid() ) then return end
   
 	local tr 	= utilx.GetPlayerTrace( player, player:GetCursorAimVector() ) 
 	local trace 	= util.TraceLine( tr )
 	
	tr.mask = MASK_WATER
	local traceline = util.TraceLine(tr)
	if traceline.Hit then
		if trace.Fraction > traceline.Fraction then
 			ent:SetNoDraw( true )
 			return
		end
	end
	if player:WaterLevel() > 0 then
 		ent:SetNoDraw( true )
 		return
	end
	if !trace.Hit or trace.HitSky then
 		ent:SetNoDraw( true )
 		return
 	end
 	if !trace.HitWorld then
 		ent:SetNoDraw( true )
		return
	end

 	local Ang = trace.HitNormal:Angle() 
 	Ang.pitch = Ang.pitch + 90 

 	local min = ent:OBBMins() 
 	ent:SetPos( trace.HitPos + trace.HitNormal * 2 ) 
 	ent:SetAngles( Ang )

 	ent:SetNoDraw( false ) 

	if trace.HitNormal:Angle().p <= 300 and trace.HitNormal:Angle().p >= 240 then
		self.GhostEntity:SetColor( 255, 255, 255, 200 )
	else
		self.GhostEntity:SetColor( 255, 0, 0, 150 )
	end
end

function SWEP:MakeGhostEntity( model, pos, angle ) 

 	util.PrecacheModel( model )

	if (SERVER && !SinglePlayer()) then return end
 	if (CLIENT && SinglePlayer()) then return end

 	// Release the old ghost entity 
 	self:ReleaseGhostEntity()

 	// Don't allow ragdolls/effects to be ghosts 
 	if (!util.IsValidProp( model )) then return end 
 	 
 	self.GhostEntity = ents.Create( "prop_physics" ) 
 	 
 	// If there's too many entities we might not spawn.. 
 	if (!self.GhostEntity:IsValid()) then 
 		self.GhostEntity = nil 
 		return 
 	end 
 	
 	self.GhostEntity:SetModel( model ) 
 	self.GhostEntity:SetPos( pos ) 
 	self.GhostEntity:SetAngles( angle ) 
 	self.GhostEntity:Spawn() 
 	 
 	self.GhostEntity:SetSolid( SOLID_VPHYSICS ); 
 	self.GhostEntity:SetMoveType( MOVETYPE_NONE );
 	self.GhostEntity:SetNotSolid( true );
 	self.GhostEntity:SetNoDraw( true );
 	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA ) 
 	self.GhostEntity:SetColor( 255, 255, 255, 150 )
 	 
end

function SWEP:ReleaseGhostEntity() 
 	 
 	if ( self.GhostEntity ) then 
 		if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end 
 		self.GhostEntity:Remove() 
 		self.GhostEntity = nil 
 	end 
 	 
 	if ( self.GhostEntities ) then 
 	 
 		for k,v in pairs( self.GhostEntities ) do 
 			if ( v:IsValid() ) then v:Remove() end 
 			self.GhostEntities[k] = nil 
 		end 
 		 
 		self.GhostEntities = nil 
 	end 
 	 
 	if ( self.GhostOffset ) then 
 	 
 		for k,v in pairs( self.GhostOffset ) do 
 			self.GhostOffset[k] = nil 
 		end 
 		 
 	end 
 	 
end

function SWEP:OnRemove()
	self:ReleaseGhostEntity()
end
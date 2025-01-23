// Chest

SWEP.Base = "weapon_base"
SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.ViewModelFOV = 64
SWEP.ViewModel = "models/weapons/v_chest.mdl"
SWEP.WorldModel = "models/props/chest/chest.mdl"

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
	function SWEP:Initialize()
		self:SetSolid( false )
		self:SetNoDraw( true )
		
		self.NextPickup = 0
		
		self:CreatePhysObj( self:GetPos(), self:GetAngles() )
	end
	
	function SWEP:PrimaryAttack()
		if ( self.NextDrop < CurTime() and self.Owner:GetEyeTrace().HitPos:Distance( self.Owner:EyePos() ) > 90 ) then		
			self.Owner:DropWeapon( self )
			
			for _, wep in ipairs( self.Owner.Class.Loadout ) do
				self.Owner:Give( wep )
			end
		end
	end
	
	function SWEP:OnDrop()		
		self:SetSolid( false )
		self:SetNoDraw( true )
		self:SetPos( vector_origin )
		
		self.NextPickup = CurTime() + 1.5
		self.DueHit = true
		self.Throwser = self.Owner
		
		self:CreatePhysObj( self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 32, self.Owner:EyeAngles() )
		timer.Simple( 0, function() self.PhysEnt:GetPhysicsObject():ApplyForceCenter( self.Owner:EyeAngles():Forward() * 50000 ) end )
	end
	
	function SWEP:CreatePhysObj( pos, ang )
		self.PhysEnt = ents.Create( "prop_physics" )
		self.PhysEnt.ChestWep = self
		self.PhysEnt:SetModel( "models/props/chest/chest.mdl" )
		self.PhysEnt:SetPos( pos )
		self.PhysEnt:SetAngles( ang )
		self.PhysEnt:Spawn()
		
		self.PhysEnt:PhysWake()
	end
else
	function SWEP:PrimaryAttack() end
end

function SWEP:SecondaryAttack() end
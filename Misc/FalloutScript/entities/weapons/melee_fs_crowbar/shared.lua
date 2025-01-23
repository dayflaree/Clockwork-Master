
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight = 1
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Repellent Stick"			
	SWEP.Author				= ""
	SWEP.Instructions = "Left Click to put a dent in some poor guys face."
	SWEP.ViewModelFOV		= 70 --this is for the model clipping on punch
	-- SWEP.Slot				= 1
	-- SWEP.SlotPos			= 1
	SWEP.IconLetter			= "f"
	SWEP.DrawCrosshair		= false
	SWEP.DrawAmmo			= false
	
        --killicon.AddFont( "weapon_deagle", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) ) Not needed for this script


end

-----------------------Main functions----------------------------
 
-- function SWEP:Reload() --To do when reloading
-- end 
function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawWorldModel(false)
	end
	self.Owner:SetNWInt( "holstertoggled", 1 )
end

function SWEP:Think() -- Called every frame

if CLIENT then return end

if ( self.Owner:GetNWInt( "holstertoggled" ) == 0 ) then
	self:SetWeaponHoldType( "melee" )  
	self.Owner:DrawWorldModel(false)
	self.Owner:DrawViewModel(true)
	-- self:DrawCrosshair( false )
	-- self:DrawAmmo( false )
elseif self.Owner:GetNWInt( "holstertoggled" ) == 1 then
	self:SetWeaponHoldType( "normal" )
	self.Owner:DrawWorldModel(false)
	self.Owner:DrawViewModel(false)
end

end

function SWEP:Initialize()
util.PrecacheSound( "physics/metal/metal_box_impact_hard1.wav" ) 
util.PrecacheSound( "physics/flesh/flesh_impact_bullet3.wav" )
util.PrecacheSound( "physics/flesh/flesh_impact_bullet4.wav" )
util.PrecacheSound( "physics/flesh/flesh_impact_bullet5.wav" )
util.PrecacheSound( "weapons/crowbar/crowbar_impact1.wav" )
util.PrecacheSound( "weapons/iceaxe/iceaxe_swing1.wav" )
-- self.Owner:DrawViewModel(true)
end

function SWEP:PrimaryAttack()
local trace = self.Owner:GetEyeTrace()
local target = trace.Entity
self.Weapon:SetNextPrimaryFire(CurTime() + .3)
self.Weapon:SetNextSecondaryFire( CurTime() + .3 )
if self.Owner:GetNWInt( "holstertoggled" ) == 1 then
return
end

if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 && self.Owner:GetNWInt( "holstertoggled" ) == 0 then

self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = math.random( 10, 50 )
	bullet.Damage = math.random( 3, 10 )
	self.Owner:FireBullets(bullet)
-- if SERVER then 
-- target:TakeDamage( math.random( 3, 10 ), Owner, Owner )
-- end
self.Owner:SetAnimation( PLAYER_ATTACK1 );
--Sounds for our crowbar
self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")

elseif trace.HitPos:Distance( self.Owner:GetShootPos() ) >= 75 && self.Owner:GetNWInt( "holstertoggled" ) == 0 then
	-- self.Weapon:SetNextPrimaryFire(CurTime() + .6)
	-- self.Weapon:SetNextSecondaryFire( CurTime() + .6 )
	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)

	
end

-- if self.Owner:GetNWInt( "holstertoggled" ) == 1 then
	-- if( not target:IsValid() or not LEMON.IsDoor or self.Owner:EyePos():Distance( target:GetPos() ) > 75 ) then
	-- return; end
	-- self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
-- end

end

function SWEP:SecondaryAttack()

local trace = self.Owner:GetEyeTrace()
local target = trace.Entity
-- if trace.HitPos:Distance( self.Owner:GetShootPos() ) < 75 and LEMON.IsDoor( target ) && self.Owner:GetNWInt( "holstertoggled" ) == 1 then
	-- self.Weapon:SetNextSecondaryFire( CurTime() + .2 )
	-- self.Weapon:EmitSound( "physics/wood/wood_crate_impact_hard2.wav" )
-- end
if self.Owner:GetNWInt( "holstertoggled" ) == 1 then
return
end
if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 && self.Owner:GetNWInt( "holstertoggled" ) == 0 then
	self.Weapon:SetNextPrimaryFire(CurTime() + .3)
	self.Weapon:SetNextSecondaryFire( CurTime() + .3 )
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = math.random( 5, 50 )
	bullet.Damage = math.random( 3, 10 )
	self.Owner:FireBullets(bullet)
-- if SERVER then 
-- target:TakeDamage( math.random( 3, 10 ), Owner, Owner )
-- end
self.Owner:SetAnimation( PLAYER_ATTACK1 );
self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")


elseif trace.HitPos:Distance( self.Owner:GetShootPos() ) >= 75 && self.Owner:GetNWInt( "holstertoggled" ) == 0 then
	self.Weapon:SetNextPrimaryFire(CurTime() + .3)
	self.Weapon:SetNextSecondaryFire( CurTime() + .3 )
	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)	
end



-- else
	-- self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	-- self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
-- end

end


-- function SWEP:Initialize()
-- if CLIENT then return end
-- if ( self:GetNWInt( "holstertoggled" ) == 1 ) then
	-- self:SetWeaponHoldType("melee")  
-- else
	-- self:SetWeaponHoldType("normal")
-- end
-- end 



-------------------------------------------------------------------

------------General Swep Info---------------
SWEP.Author   = "Otoris"
SWEP.Contact        = ""
SWEP.Purpose        = "Bashing peoples faces in."
SWEP.Instructions   = "Left/Right click to swing."
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
-----------------------------------------------

------------Models---------------------------
SWEP.ViewModel      = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel   = "models/weapons/w_crowbar.mdl"
-----------------------------------------------

-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.3 	--In seconds
SWEP.Primary.Recoil			= 0.1		--Gun Kick
SWEP.Primary.Damage			= 10	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type
-------------End Primary Fire Attributes------------------------------------
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 0.3
SWEP.Secondary.Recoil		= 0.1
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"
-------------End Secondary Fire Attributes--------------------------------
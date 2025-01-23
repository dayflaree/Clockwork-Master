
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight = 1
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	resource.AddFile( "models/weapons/v_fists.dx90.vtx" )
	resource.AddFile( "models/weapons/v_fists.dx80.vtx" )
	resource.AddFile( "models/weapons/v_fists.mdl" )
	resource.AddFile( "models/weapons/v_fists.sw.vtx" )
	resource.AddFile( "models/weapons/v_fists.vvd" )
	resource.AddFile( "models/weapons/w_fists.dx80.vtx" )
	resource.AddFile( "models/weapons/w_fists.dx90.vtx" )
	resource.AddFile( "models/weapons/w_fists.mdl" )
	resource.AddFile( "models/weapons/w_fists.phy" )
	resource.AddFile( "models/weapons/w_fists.sw.vtx" )
	resource.AddFile( "models/weapons/w_fists.vvd" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Hands"			
	SWEP.Author				= ""
	SWEP.Instructions = "Right click to knock on doors.\n Toggle your holster to punch left/right click."
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
util.PrecacheSound("physics/wood/wood_crate_impact_hard2.wav") 
util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")
util.PrecacheSound("physics/flesh/flesh_impact_bullet4.wav")
util.PrecacheSound("physics/flesh/flesh_impact_bullet5.wav")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
-- self.Owner:DrawViewModel(true)
end

function SWEP:PrimaryAttack()
local trace = self.Owner:GetEyeTrace()
local target = trace.Entity
self.Weapon:SetNextPrimaryFire(CurTime() + .6)
self.Weapon:SetNextSecondaryFire( CurTime() + .6 )
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
	bullet.Force  = math.random( 5, 30 )
	bullet.Damage = 0
--self.Owner:FireBullets(bullet)
if SERVER then 
target:TakeDamage( math.random( 5, 8 ), Owner, Owner )
end
self.Owner:SetAnimation( PLAYER_ATTACK1 );
self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
elseif trace.HitPos:Distance( self.Owner:GetShootPos() ) >= 75 && self.Owner:GetNWInt( "holstertoggled" ) == 0 then
	-- self.Weapon:SetNextPrimaryFire(CurTime() + .6)
	-- self.Weapon:SetNextSecondaryFire( CurTime() + .6 )
	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	
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
if trace.HitPos:Distance( self.Owner:GetShootPos() ) < 75 and LEMON.IsDoor( target ) && self.Owner:GetNWInt( "holstertoggled" ) == 1 then
	self.Weapon:SetNextSecondaryFire( CurTime() + .2 )
	self.Weapon:EmitSound( "physics/wood/wood_crate_impact_hard2.wav" )
end
if self.Owner:GetNWInt( "holstertoggled" ) == 1 then
return
end
if trace.HitPos:Distance( self.Owner:GetShootPos() ) <= 74 then
	self.Weapon:SetNextPrimaryFire(CurTime() + .6)
	self.Weapon:SetNextSecondaryFire( CurTime() + .6 )
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = math.random( 5, 12 )
	bullet.Damage = math.random( 0, 8 )
	-- self.Owner:FireBullets(bullet)
if SERVER then 
target:TakeDamage( math.random( 5, 8 ), Owner, Owner )
end
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
else
	self.Weapon:SetNextPrimaryFire(CurTime() + .6)
	self.Weapon:SetNextSecondaryFire( CurTime() + .6 )
	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)	
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
SWEP.Purpose        = "To beat someone or something up."
SWEP.Instructions   = "Left/Right click to punch."
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
-----------------------------------------------

------------Models---------------------------
SWEP.ViewModel      = "models/weapons/v_fists.mdl"
SWEP.WorldModel   = ""
-----------------------------------------------

-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.9 	--In seconds
SWEP.Primary.Recoil			= 0.2		--Gun Kick
SWEP.Primary.Damage			= 5	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= false	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type
-------------End Primary Fire Attributes------------------------------------
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0.2
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
-------------End Secondary Fire Attributes--------------------------------
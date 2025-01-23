

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then
	--SWEP.Category 			= "Fallout Weapons";
	SWEP.PrintName			= ".32 Hunting Rifle"			
	--SWEP.Author				= "Otoris"
	--SWEP.ViewModelFOV      = 40
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "o"
	
	killicon.AddFont( "weapon_scout", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

function SWEP:Deply()

	self.Owner:SetNWInt( "holstertoggled", 0 )
	self.Owner:SetNWString( "WepIcon", self.IconLetter )
	
end

function SWEP:Think() -- Called every frame

if CLIENT then return end

if ( self.Owner:GetNWInt( "holstertoggled" ) == 0 ) then
	self:SetWeaponHoldType("pistol")  
	self.Owner:DrawWorldModel(true)
	self.Owner:DrawViewModel(true)
	self:SetNextPrimaryFire( self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() )
elseif self.Owner:GetNWInt( "holstertoggled" ) == 1 then
	self:SetWeaponHoldType("normal")
	self.Owner:DrawWorldModel(false)
	self.Owner:DrawViewModel(false)
	self:SetNextPrimaryFire( CurTime() + 1000000 )
	self:SetNextSecondaryFire( CurTime() + 1000000 )
end

end
SWEP.Base				= "weapon_cs_base"
SWEP.ViewModelFlip		= true

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel 			= "models/weapons/v_snip_rifle.mdl"
SWEP.WorldModel 		= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 8
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_SCOUT.Single" )
SWEP.Primary.Recoil			= 0.0001
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= 5
SWEP.Primary.Delay			= 1.8
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector (4.9913, -6.0786, 3.0302)
SWEP.IronSightsAng = Vector (0, 0, 0)


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Desert Eagle .44"			
	--SWEP.Author				= ""

	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "f"
	
	killicon.AddFont( "weapon_deagle", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

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
	self:SetNextPrimaryFire( CurTime() )
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
SWEP.Category			= "Fallout Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= math.random( 10, 16 )
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 48
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 5.15, -2, 2.6 )

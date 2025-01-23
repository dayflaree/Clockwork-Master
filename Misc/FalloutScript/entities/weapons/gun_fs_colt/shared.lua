

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "pistol"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Colt .45"			
	--SWEP.Author				= ""
	SWEP.Slot				= 1
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "u"
	
	killicon.AddFont( "weapon_fiveseven", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end
function SWEP:Deply()

	self.Owner:SetNWInt( "holstertoggled", 1 )
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

-- function SWEP:PrimaryFire()
-- local randomjam = math.random( 1, 100 )
	-- if ( randomjam <= 50 ) then
		-- self:SetNextPrimaryFire( CurTime() + 1000000 )
	-- end
-- end

-- function SWEP:Reload()

	-- self:SetNextPrimaryFire( CurTime() )

-- end

SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "Fallout Weapons"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Recoil			= 1.2
SWEP.Primary.Damage			= math.random( 5, 12 )
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.05
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 4.5, -4, 3 )


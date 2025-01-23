if ( SERVER ) then

    AddCSLuaFile("sh_auto.lua");
    
    SWEP.HoldType            = "ar2"
    
end

if ( CLIENT ) then

    SWEP.PrintName            = "The Bastard"            
    SWEP.Author                = "DanRod"
    SWEP.Slot                = 3
    SWEP.SlotPos            = 1
    SWEP.IconLetter            = "b"
    
    killicon.AddFont( "weapon_ak47", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
    
end


SWEP.Base                = "weapon_cs_base"
SWEP.Category            = "Metro 2033"

SWEP.Spawnable            = true
SWEP.AdminSpawnable        = false

SWEP.ViewModel            = "models/weapons/v_smg_tin.mdl"
SWEP.WorldModel            = "models/weapons/w_smg1.mdl"

SWEP.Weight                = 5
SWEP.AutoSwitchTo        = false
SWEP.AutoSwitchFrom        = false

SWEP.Primary.Sound            = Sound( "weapons/tin/fire-1.wav" )
SWEP.Primary.Recoil            = 1.3
SWEP.Primary.Damage            = 12
SWEP.Primary.NumShots        = 1
SWEP.Primary.Cone            = 0.02
SWEP.Primary.ClipSize        = 25
SWEP.Primary.Delay            = 0.140
SWEP.Primary.DefaultClip    = 30
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "smg1"

SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none"

SWEP.IronSightsPos = Vector (4.1795, -4.3946, 1.6796)
SWEP.IronSightsAng = Vector (1.269, -0.844, 0)

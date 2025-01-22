--REAL CS BASE
--sorry for no comments to show what everything does im too lazy to do it LOL!

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5


end

if ( CLIENT ) then
	SWEP.PrintName			= "MP7"	
	SWEP.Author				= "Piciul"
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "x"
	SWEP.ViewModelFlip		= false
	SWEP.ViewModelFOV		= 54
	SWEP.DefaultVFOV		= 54
	SWEP.NameOfSWEP			= "rcs_mp7" --always make this the name of the folder the SWEP is in.
	killicon.AddFont( SWEP.NameOfSWEP, "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

SWEP.Category				= "RealCS"
SWEP.Base					= "rcs_base"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
	SWEP.HoldType			= "ar2"
SWEP.ViewModel				= "models/weapons/v_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.Penetrating = true
SWEP.Weight					= 2.5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Sound			= Sound( "Weapon_SMG1.NPC_Single" )
SWEP.Primary.Recoil			= 0.23
SWEP.Primary.Damage			= 19
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001 --starting cone, it WILL increase to something higher, so keep it low
SWEP.Primary.ClipSize		= 45
SWEP.Primary.Delay			= 0.075
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.MaxReserve		= 1000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Primary.MaxSpread		= 0.092 --the maximum amount the spread can go by, best left at 0.20 or lower
SWEP.Primary.Handle			= 0.5 --how many seconds you have to wait between each shot before the spread is at its best
SWEP.Primary.SpreadIncrease	= 0.21/15 --how much you add to the cone after each shot

SWEP.MoveSpread				= 5 --multiplier for spread when you are moving
SWEP.JumpSpread				= 6 --multiplier for spread when you are jumping
SWEP.CrouchSpread			= 0.6 --multiplier for spread when you are crouching


SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.ReloadLol = Sound("Weapon_SMG1.Reload");

SWEP.IronSightsPos = Vector (-6.4101, -10.3476, 2.5264)
SWEP.IronSightsAng = Vector (0.2222, 0.0749, 0)

function SWEP:Precache()

    	util.PrecacheSound("weapons/smg1/smg1_reload.wav")
end

function SWEP:ReloadLol()

	if (self.ActionDelay > CurTime()) then return end 

	self.Weapon:DefaultReload(ACT_VM_RELOAD) 

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self.Owner:SetFOV( 0, 0.15 )
		self.Weapon:EmitSound(self.Primary.Reload)
	end
end
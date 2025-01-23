--[[if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )

end

if ( CLIENT ) then


	SWEP.PrintName		= "Rocket Launcher"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70" // 70
	SWEP.Instructions	= "Shoot rockets!"
	SWEP.Slot		= 5
	SWEP.Slotpos 		= 0
	SWEP.CSMuzzleFlashes	= true
end

SWEP.data = {}
SWEP.data.newclip			= false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/Weapons/v_RPG.mdl"
SWEP.WorldModel			= "models/Weapons/w_rocket_launcher.mdl"
SWEP.ViewModelFlip		= false

SWEP.Primary.Sound		= Sound( "weapons/stinger_fire1.wav" )
SWEP.Primary.Recoil		= 0.03
SWEP.Primary.Damage		= 19
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.01
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay		= 1
SWEP.Primary.DefaultClip	= 4
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "RPG_Round"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"
]]--

if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" ) 

 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.DrawCrosshair = false;

end
 
SWEP.Base = "ts2_base";
   
SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= true 

SWEP.WorldModel = "models/weapons/w_rpg7.mdl";
SWEP.ViewModel = "models/weapons/v_RL7.mdl";
SWEP.Primary.Sound		= Sound( "weapons/stinger_fire1.wav" )
SWEP.PrintName = "RPG 7 Launcher";
SWEP.TS2Desc = "Rocket Propelled Grenade Tube";

SWEP.Price = 18000;

SWEP.Primary.Recoil			= .7 
SWEP.Primary.RecoilAdd			= .3
SWEP.Primary.RecoilMin = .3
SWEP.Primary.RecoilMax = .6
 
SWEP.Primary.ViewPunchMul = 3;
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1 

SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 10;
SWEP.Primary.Ammo = "RPGS";
SWEP.Primary.Delay = 0.3;
SWEP.Primary.SpreadCone = Vector( 0,0,0 );
SWEP.Primary.ReloadDelay = 2.3;

SWEP.Primary.IronSightPos = Vector( -3.74, 0.2, -5 );
SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );
SWEP.ItemWidth = 4;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 11, -163, 5 );
SWEP.IconLookAt = Vector( 20, 7, -1 );
SWEP.IconFOV = 19;

SWEP.ReloadSound = "";


function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack() ) then return end

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo( 1 )

	self:TakePrimaryAmmo( 0 )
	self.Owner:ViewPunch( Angle( -1.00, 0, 0 ) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	local shotpos = self.Owner:GetShootPos()
	shotpos = shotpos + self.Owner:GetForward() * 30
	shotpos = shotpos + self.Owner:GetRight() * 10
	shotpos = shotpos + self.Owner:GetUp() * 5

	if (SERVER) then
			
		local rocket = ents.Create("rocket")
		if (ValidEntity(rocket)) then
			rocket:SetPos(shotpos)
			rocket:SetAngles(self.Owner:EyeAngles())
			rocket:SetOwner(self.Owner)
 			rocket:Spawn()
			rocket.Owner = self.Owner
		end


		local b = ents.Create( "info_target" )
		if (ValidEntity(b)) then
			b:SetPos( self.Owner:GetEyeTrace( ).HitPos + Vector(0,0,0))
			b:Spawn( )
			rocket:PointAtEntity( b )
			b:Remove( )
		end
	end

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Reload()
	if self.Owner:GetActiveWeapon():Clip1() == self.Primary.ClipSize then return end
	if self.Reloading || self.Owner:GetAmmoCount( "RPG_Round" ) == 0 then return end
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		self.data.oldclip = self.Weapon:Clip1()
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
		self.data.newclip = 1
	end
end

function SWEP:Deploy()
	--self.Weapon:EmitSound(Sound("weapons/pistol_ready.wav"))
end
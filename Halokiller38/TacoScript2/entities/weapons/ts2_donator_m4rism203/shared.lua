--[[if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	SWEP.HoldType			= "smg"
end

if ( CLIENT ) then


	SWEP.PrintName		= "Grenade Launcher"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70" // 70
	SWEP.Instructions	= "Click to fire Grenades"
	SWEP.Slot		= 5
	SWEP.Slotpos 		= 0
	SWEP.CSMuzzleFlashes	= true
end

SWEP.data = {}
SWEP.data.newclip			= false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.ViewModelFlip		= false

SWEP.Primary.Sound		= Sound( "weapons/grenade_launcher1.wav" )
SWEP.Primary.Recoil		= 0.06
SWEP.Primary.Damage		= 19
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.01
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay		= 0.3
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "RPG_Round"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.IronSightsPos = Vector (4.2399, 0, 0.2073)
SWEP.IronSightsAng = Vector (0, 0, 0)
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
   
SWEP.WorldModel = "models/weapons/w_smg4.mdl";
SWEP.ViewModel = "models/weapons/v_smg4.mdl";

SWEP.PrintName = "M4 RIS - M203";
SWEP.TS2Desc = "40mm Grenade Launcher";

SWEP.Price = 10000;

SWEP.Primary.Recoil			= .7 
SWEP.Primary.RecoilAdd			= .3
SWEP.Primary.RecoilMin = .3
SWEP.Primary.RecoilMax = .6
 
SWEP.Primary.ViewPunchMul = 2;
SWEP.Primary.Damage			= 300
SWEP.Primary.NumShots		= 1 

SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 6;
SWEP.Primary.Ammo = "RPGS";
SWEP.Primary.Delay = 0.3;
SWEP.Primary.SpreadCone = Vector( 0,0,0 );
SWEP.Primary.ReloadDelay = 2.3;

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.Primary.IronSightPos = Vector( -4.1842, 1.5686 , -8.1373 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 3, -45, -10 ) 
SWEP.IconLookAt = Vector( 1, -7, -2 )
SWEP.IconFOV = 20;

SWEP.ReloadSound = "";



function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	self.Weapon:EmitSound("weapons/grenade_launcher1.wav", 110, 50)

	self:TakePrimaryAmmo( 1 )

	self:TakePrimaryAmmo( 0 )
	self.Owner:ViewPunch( Angle( -1.00, 0, 0 ) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	local shotpos = self.Owner:GetShootPos()
	shotpos = shotpos + self.Owner:GetForward() * 25
	--shotpos = shotpos + self.Owner:GetRight() 
	shotpos = shotpos + self.Owner:GetUp() * -13
	shotpos = shotpos + self.Owner:GetRight() * 9

	if (SERVER) then
			
		local rocket = ents.Create("tnb_shotnade")
		if (ValidEntity(rocket)) then
			rocket:SetPos(shotpos)
			rocket:SetAngles(self.Owner:EyeAngles())
			rocket:SetOwner(self.Owner)
 			rocket:Spawn()
			rocket.Owner = self.Owner
		end
--[[
		local Trail = ents.Create("env_rockettrail")
		Trail:SetPos(rocket:GetPos() - 16*rocket:GetForward())
		Trail:SetParent(rocket)
		Trail:SetLocalAngles(Vector(0,0,0))
		Trail:SetKeyValue("scale", "0.2")
		Trail:Spawn()
]]--

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

local IRONSIGHT_TIME = 0.25
/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.9
		else 
			self.SwayScale 	= 2.0
			self.BobScale 	= 3.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end


/*---------------------------------------------------------
	SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end


SWEP.NextSecondaryAttack = 0
/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
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

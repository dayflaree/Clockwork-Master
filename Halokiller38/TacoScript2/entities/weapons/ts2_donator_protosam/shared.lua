
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.WorldModel = "models/weapons/w_combine_sam_kit.mdl";
SWEP.ViewModel = "models/weapons/v_sam.mdl";

SWEP.PrintName = "Tac-SAM";
SWEP.TS2Desc = "Multi Purpose Anti-Armour Rocketlauncher";

SWEP.Price = 45000;

 SWEP.Primary.Recoil			= .7 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .6
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 300
 SWEP.Primary.NumShots		= 1 
 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.ClipSize = 3;
SWEP.Primary.DefaultClip = 3;
SWEP.Primary.Ammo = "RPGS";
SWEP.Primary.Delay = 0.9;
SWEP.Primary.SpreadCone = Vector( .03, .03, .03 );
SWEP.Primary.ReloadDelay = 2.3;

SWEP.Primary.IronSightPos = Vector( -3.74, 0.2, -5 );
SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 2;

SWEP.IconCamPos = Vector( 11, -163, 5 );
SWEP.IconLookAt = Vector( 20, 7, -1 );
SWEP.IconFOV = 19;

SWEP.ReloadSound = "";

SWEP.settings = {}
SWEP.settings.loaded = true
SWEP.settings.warhead = "sent_stinger"
SWEP.SetNextReload = 0
SWEP.reloadtimer = 2.3
SWEP.settings.warheads = {}
SWEP.settings.warheadnumber = 1
SWEP.Warheadsloaded = false
SWEP.settings.warheadchoosing = false
SWEP.settings.warheadpressed = false
SWEP.settings.warheadcount = 0


function SWEP:HolsterToggle()

	self.Owner:ConCommand( "eng_seescope 0\n" );

end

if( CLIENT ) then

	SeeSniperScope = false;

	function SWEP:DrawHUD()

		if( math.floor( self.Primary.PositionMode ) == 1 and math.floor( self.Primary.PositionMul ) == 1 ) then 

			if( not SeeSniperScope ) then
			
				RunConsoleCommand( "eng_seescope", "1" );
				SeeSniperScope = true;

			end

		else
		
			if( SeeSniperScope ) then
			
				RunConsoleCommand( "eng_seescope", "0" );
				SeeSniperScope = false;
				
			end
			
		end
		
	end
	
end
   
function SWEP:Initialize()

	for k,v in pairs(scripted_ents.GetList()) do
		if string.find(v.t.Classname, "sent_stinger") then
			table.insert(self.settings.warheads,v) 
		end
	end
	
	self.settings.warheadcount = table.Count(self.settings.warheads)

	self.settings.loaded = true
	util.PrecacheSound( "weapons/rpg.wav" )
	
end
 
 
function SWEP:Rocket()

	if ( !SERVER ) then return end

	local warhead = self.settings.warhead
	local rocket = ents.Create( warhead )	
	
	rocket:SetOwner( self.Owner )
	
	if ( self.Ironsights == false ) then
		local v = self.Owner:GetShootPos()
		v = v + self.Owner:GetForward() 
		v = v + self.Owner:GetRight() 
		v = v + self.Owner:GetUp() 
		rocket:SetPos( v )	
	else
		rocket:SetPos( self.Owner:GetShootPos() )
	end
	
	rocket:SetAngles( self.Owner:GetAngles() )
	rocket:Spawn()
	rocket:Activate()
	
	local physObj = rocket:GetPhysicsObject()
	
	self.Owner:ViewPunch( Vector( math.Rand( 0, -10 ), math.Rand( 0, 0 ), math.Rand( 0, 0 ) ) )	
	self.settings.loaded = false
	
end

function SWEP:Reload()

	if( self.settings.loaded == true ) then return; end
	
	self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
	self.Weapon:SetNextPrimaryFire( CurTime() + 2.3 )
	self.settings.loaded = true

end

function SWEP:PrimaryAttack()

	if self.settings.loaded and not self.warheadchoosing then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:Rocket( self.Owner:GetAimVector() )
		self.Weapon:SetNextPrimaryFire( CurTime() + 300 )
		self.Weapon:EmitSound( "weapons/rpg.wav" )
		
		if (SERVER) then
			self.Owner:SetFOV( 90, 2.3 )
		end
		
	end
	
end
   
  
function SWEP:Deploy()

	if not self.Warheadsloaded then
	
		for k,v in pairs(scripted_ents.GetList()) do
			if string.find(v.t.Classname, "sent_stinger") then
				table.insert(self.settings.warheads,v)
			end
		end
		
		self.settings.warheadcount = table.Count(self.settings.warheads)
		self.Warheadsloaded = true
		
	end

	self.settings.loaded = true
	
end 
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" )
 
 end 

 
 SWEP.Base = "ep_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 
   
if( CLIENT ) then

	SWEP.DrawCrosshair = false;

end

SWEP.HoldType = "pistol";


SWEP.ViewModel      = "models/weapons/melee/v_chainsaw.mdl"
SWEP.WorldModel   = "models/weapons/necropolis/w_models/w_chainsaw.mdl"

SWEP.PrintName = "Chainsaw";
SWEP.EpiDesc = "Cut down trees";

SWEP.EpiHoldType = "RIFLE";

SWEP.Degrades = false;

SWEP.Primary.AmmoType = -1;

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Angle( 0.0, -50.0, 0.0 );
SWEP.Primary.Delay = 0;
SWEP.Primary.Automatic = true;

SWEP.ItemWidth = 4;
SWEP.ItemHeight = 3;

SWEP.IconCamPos = Vector( -104, -40, 0 ) 
SWEP.IconLookAt = Vector( -9, 0, 1 ) 
SWEP.IconFOV = 18
SWEP.HUDWidth = 200;
SWEP.HUDHeight = 150;
SWEP.NicePhrase = "a chainsaw";
SWEP.HeavyWeight = true;

SWEP.L4D = true;
SWEP.NoHolster = true;

SWEP.OverridePrimary = true;
SWEP.NextRefreshIdle = 0;
SWEP.AttackMul = 0;

SWEP.IdleLoop = nil;
SWEP.AttackLoop = nil;

SWEP.NextBreak = 0;

function SWEP:Holster()
	
	if( !self.On ) then return false end
	
	if( SERVER ) then
		
		if( self.AttackLoop ) then
			
			self.AttackLoop:ChangeVolume( 0 );
			self.AttackLoop:Stop();
			
		end
		
		if( self.IdleLoop ) then
			
			self.IdleLoop:ChangeVolume( 0 );
			self.IdleLoop:Stop();
			
		end
		
		self.AttackLoop = nil;
		self.IdleLoop = nil;
		
	end
	
	self.Arms = nil;
	
	return true;
	
end

function SWEP:Deploy()
	
	self:SendWeaponAnim( ACT_VM_DRAW );
	self.On = false;
	
	self:EmitSound( table.Random( {
		Sound( "weapons/necropolis/chainsaw/chainsaw_start_01.wav" ),
		Sound( "weapons/necropolis/chainsaw/chainsaw_start_02.wav" );
	} ), 90, 100 );
	
	timer.Simple( self:SequenceDuration(), function()
		
		if( self and self:IsValid() and self.Owner and self.Owner:Alive() ) then
			
			self.On = true;
			self:SendWeaponAnim( ACT_VM_IDLE );
			
		end
		
	end );
	
	if( self.L4D and CLIENT ) then
		
		self.Arms = ClientsideModel( "models/weapons/necropolis/v_models/v_l4d2arms.mdl" );
		
	end
	
	return true;
	
end

function SWEP:Think()
	
	if( CurTime() >= self.NextRefreshIdle and self.On ) then
		
		self:SendWeaponAnim( ACT_VM_IDLE );
		self.Owner:GetViewModel():SetPoseParameter( "engine_on", 1.0 );
		self.NextRefreshIdle = CurTime() + self:SequenceDuration();
		
	end
	
	if( !self.IdleLoop and self.On ) then
		
		self.IdleLoop = CreateSound( self.Owner, Sound( "weapons/necropolis/chainsaw/chainsaw_idle_lp_01.wav" ) );
		self.IdleLoop:Play();
		self.IdleLoop:ChangeVolume( 0.2 );
		
	end
	
	if( self.Owner:KeyDown( IN_ATTACK ) ) then
		
		self.AttackMul = math.Clamp( self.AttackMul + 0.05, 0, 1 );
		
		if( SERVER and self.On ) then
			
			if( !self.AttackLoop ) then
				
				self.AttackLoop = CreateSound( self.Owner, Sound( "weapons/necropolis/chainsaw/chainsaw_high_speed_lp_01.wav" ) );
				self.AttackLoop:Play();
				
				if( self.IdleLoop ) then
					
					self.IdleLoop:ChangeVolume( 0 );
					
				end
				
			end
			
		end
		
	else
		
		self.AttackMul = math.Clamp( self.AttackMul - 0.05, 0, 1 );
		
		if( SERVER ) then
			
			if( self.AttackLoop ) then
				
				self.AttackLoop:Stop();
				
			end
			
			if( self.IdleLoop ) then
				
				self.IdleLoop:ChangeVolume( 0.2 );
				
			end
			
			self.AttackLoop = nil;
			
		end
		
	end
	
	if( self.AttackMul > 0 and self.On ) then
		
		self.Owner:ViewPunch( Angle( math.random( -self.AttackMul, self.AttackMul ), math.random( -self.AttackMul, self.AttackMul ), 0 ) );
		
	end
	
	if( self.AttackMul > 0.9 ) then
		
		if( SERVER ) then
			
			local trace 	= { };
			trace.start 	= self.Owner:EyePos();
			trace.endpos	= trace.start + self.Owner:GetAimVector() * 50;
			trace.filter 	= self.Owner;
			
			local tr 		= util.TraceLine( trace );
			
			local tbl 		= ents.FindInSphere( tr.HitPos, 20 );
			
			for k, v in pairs( tbl ) do
				
				if( v ~= self.Owner and not string.find( v:GetClass(), "func_" ) ) then
					
					local norm = ( self.Owner:GetPos() - v:GetPos() ):Normalize();
					
					local dmgpos = v:GetPos();
					dmgpos.z = tr.HitPos.z;
					
					HandleChainsawDamage( v, 1, 10, dmgpos, self.Owner );
					
				elseif( ( v:GetClass() == "func_breakable" or v:GetClass() == "func_breakable_surf" ) and CurTime() >= self.NextBreak ) then
					
					self.NextBreak = CurTime() + 0.1;
					v:Fire( "Break", "", 0 );
					
				end
				
			end
			
		end
		
	end
	
end

function SWEP:ViewModelDrawn()
	
	if( self.Arms ) then
		
		self:ValidateArms();
		self.Arms:DrawModel();
		
	end
	
	self.Owner:GetViewModel():SetPoseParameter( "attack", self.AttackMul );
	
end
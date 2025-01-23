if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
	
end 
 
SWEP.HoldType = "pistol";

 
SWEP.Base = "ts2_base";
   
SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= false 

SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );


SWEP.PrintName = "Hands";
SWEP.TS2Desc = "Pick up things or punch someone\n(HOLSTERED) Left click - Knock  on door/Throw\n(HOLSTERED) Right click - Pick up/drop\n(UNHOLSTERED) Left click - Punch\n";


SWEP.Primary.ViewPunchMul = .5;
SWEP.Primary.Damage			= 5 
SWEP.Primary.NumShots		= 1 

SWEP.TS2HoldType = "FIST";

SWEP.Slot = 1;

SWEP.Primary.CanCauseBleeding = false;

SWEP.Primary.ClipSize = 0;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Delay = .07;
SWEP.Primary.Automatic = true;

SWEP.Primary.IronSightPos = Vector( 0, 5.5, -5.0 );
SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( -2.4, -4, -12.0 );

SWEP.LastPickUp = 0;

SWEP.ItemWidth = 0;
SWEP.ItemHeight = 0;

SWEP.LastReload = 0;

function SWEP:Initialize()

	self.HitSounds = {
	
		Sound( "npc/vort/foot_hit.wav" ),
		Sound( "weapons/crossbow/hitbod1.wav" ),
		Sound( "weapons/crossbow/hitbod2.wav" )
	}
	
	self.SwingSounds = {
	
		Sound( "npc/vort/claw_swing1.wav" ),
		Sound( "npc/vort/claw_swing2.wav" )
	
	}

end

function SWEP:Reload()

	return;

end

SWEP.NextPrimaryAttack = 0;

function SWEP:PrimaryAttack()

	if( SERVER and self.Owner:IsTied() ) then return; end 

	if( CurTime() < self.NextPrimaryAttack ) then return; end

	if( ( SERVER and self.Owner:GetPlayerHolstered() ) or ( CLIENT and ClientVars["Holstered"] ) ) then
	
		if( SERVER ) then
	
			if( self.Owner.HandPickUpSent and self.Owner.HandPickUpSent:IsValid() and self.Owner.HandPickUpTarget and self.Owner.HandPickUpTarget:IsValid() ) then
			
				local ent = self.Owner.HandPickUpTarget;
				self.Owner:RemoveHandPickUp();
				self.Owner.HandPickUpTarget:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * 1000 );
	
				return;
	
			end
			
		end
		
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 50;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
			self.Weapon:EmitSound( Sound( "physics/wood/wood_crate_impact_hard2.wav" ) );
			self.NextPrimaryAttack = CurTime() + 0.3;
			
		end
	
	else
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
		trace.filter = self.Owner;
  	
		local tr = util.TraceLine( trace );
	
		self.Weapon:EmitSound( self.SwingSounds[math.random( 1, #self.SwingSounds )] );
		
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
		self.NextPrimaryAttack = CurTime() + 1;
		
		if( tr.Hit or tr.Entity:IsValid() ) then
		
			self.Weapon:EmitSound( self.HitSounds[math.random( 1, #self.HitSounds )] );
		
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
			self.NextPrimaryAttack = CurTime() + 1;

			if( tr.Entity:IsPlayer() ) then
			
				local norm = ( tr.Entity:GetPos() - self.Owner:GetPos() ):Normalize();
				local push = 2000 * norm;
				
				push = 50 * norm;
				
				tr.Entity:SetVelocity( push );
			  
				self:ShootBullet(self.Primary.Damage, 1, 0.0)
			end
			
		end
		
	end

	

end

function SWEP:SecondaryAttack()

	if( CLIENT ) then return; end
	
	if( self.Owner:IsTied() ) then return; end
	
	if( self.Owner:GetPlayerHolstered() ) then

		if( self.Owner.HandPickUpSent and self.Owner.HandPickUpSent:IsValid() ) then
			self.Owner:RemoveHandPickUp();
		elseif( CurTime() - self.LastPickUp > 1 ) then
	
			local trace = { }
			trace.start = self.Owner:EyePos();
			trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
			trace.filter = self.Owner;
			
			local tr = util.TraceLine( trace );
			
			if( tr.Entity and tr.Entity:IsValid() ) then
			
				self.Owner:HandPickUp( tr.Entity, tr.PhysicsBone );
			
			end
			
			self.LastPickUp = CurTime();
			
		end

	else
	
	end

end

function SWEP:HolsterToggle()

	if( self.Owner.HandPickUpSent and self.Owner.HandPickUpSent:IsValid() ) then
		self.Owner:RemoveHandPickUp();
	end
	
	if( self.Owner.RightHandEntity and self.Owner.RightHandEntity:IsValid() ) then
	
		self.Owner.RightHandEntity:Remove();
		self.Owner.RightHandEntity = nil;
	
	end 

end


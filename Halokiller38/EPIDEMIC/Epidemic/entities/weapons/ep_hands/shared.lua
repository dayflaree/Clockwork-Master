if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 

 SWEP.HoldType = "pistol";
 
 SWEP.Base = "ep_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 
   


SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );


SWEP.PrintName = "Hands";
SWEP.EpiDesc = "";

 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 5 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.EpiHoldType = "FIST";

SWEP.Slot = 1;

SWEP.Degrades = false;

SWEP.Primary.ClipSize = 0;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Delay = .07;
SWEP.Primary.Automatic = true;

 SWEP.Primary.IronSightPos = Vector( 0, 5.5, -5.0 );
 SWEP.Primary.IronSightAng = Angle( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( -2.4, -4, -12.0 );

SWEP.LastPickUp = 0;

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


end

SWEP.NextPrimaryAttack = 0;

function SWEP:PrimaryAttack()

	if( CurTime() < self.NextPrimaryAttack ) then return; end

	if( self.Owner:GetNWBool( "Holstered", true ) ) then
	
		if( SERVER ) then

			if( self.Owner:GetTable().HandPickUpSent and self.Owner:GetTable().HandPickUpSent:IsValid() and self.Owner:GetTable().HandPickUpTarget and self.Owner:GetTable().HandPickUpTarget:IsValid() ) then

				local ent = self.Owner:GetTable().HandPickUpTarget;
				self.Owner:RemoveHandPickUp();
				self.Owner:GetTable().HandPickUpTarget:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * 1000 );
	
				return;
	
			end
			
		end
		
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 30;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		--if( tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
			--self.Weapon:EmitSound( Sound( "physics/wood/wood_crate_impact_hard2.wav" ) );
			--self.NextPrimaryAttack = CurTime() + math.Rand( .2, .7 );
			
		--end
	
	else
	
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
		self.NextPrimaryAttack = CurTime() + math.Rand( .4, .6 );

		self.Weapon:EmitSound( self.SwingSounds[math.random( 1, #self.SwingSounds )] );

	  	local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
		trace.filter = self.Owner;
	  	
	  	local tr = util.TraceLine( trace );

		if( tr.Hit or tr.Entity:IsValid() ) then
			
			if( SERVER ) then
				
				if( tr.Entity:IsValid() ) then
			
					local norm = ( tr.Entity:GetPos() - self.Owner:GetPos() ):Normalize();
					local push = 500 * norm;
					
					if( tr.Entity:IsPlayer() ) then

						push = 50 * norm;
						tr.Entity:SetVelocity( push );
						
						HandleMeleeDamage( tr.Entity, 0, 4, tr.HitPos );
					
	
					else
						
						if( tr.Entity:GetPhysicsObject() and tr.Entity:GetPhysicsObject():IsValid() ) then
							
							tr.Entity:GetPhysicsObject():ApplyForceOffset( push, tr.HitPos );
							
						end
					
						HandleMeleeDamage( tr.Entity, math.random( 1, 2 ), 4, tr.HitPos );
					
					end
				
				end
				
			end
			
			self.Weapon:EmitSound( self.HitSounds[math.random( 1, #self.HitSounds )] );
			
		end
	
	end

end

function SWEP:SecondaryAttack()

	

end

function SWEP:HolsterToggle()

	if( self.Owner:GetTable().HandPickUpSent and self.Owner:GetTable().HandPickUpSent:IsValid() ) then
		self.Owner:RemoveHandPickUp();
	end

end


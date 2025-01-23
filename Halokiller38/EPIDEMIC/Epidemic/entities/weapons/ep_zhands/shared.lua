if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 

 SWEP.HoldType = "pistol";
 
 SWEP.Base = "ep_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 
   


SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );

SWEP.ViewModel = Model( "models/weapons/w_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );


SWEP.PrintName = "Zombie Hands";
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

SWEP.LastSmokeSound = 0;

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
	
	self.Primary.CanToggleHolster = false;
 	self.Primary.HolsteredAtStart = false;

end

function SWEP:Reload()


end

function SWEP:Think() 
	
	if( SERVER ) then
		
		if( string.find( self.Owner:GetModel(), "smoker.mdl" ) or string.find( self.Owner:GetModel(), "smoker2.mdl" ) ) then
			
			if( self.Owner:KeyDown( IN_ATTACK2 ) ) then
				
				if( self.Owner.TonguePlayer ) then
					
					local vel = ( self.Owner.TonguePlayer:GetPos() - self.Owner:GetPos() ):Normalize() * -30;
					self.Owner.TonguePlayer:SetVelocity( vel );
					
				else
					
					local trace = { }
					trace.start = self.Owner:EyePos();
					trace.endpos = trace.start + self.Owner:GetAimVector() * 1024;
					trace.filter = self.Owner;
					
					local tr = util.TraceLine( trace );
					
					local ent = nil;
					
					for _, v in pairs( player.GetAll() ) do
						
						if( v:GetPos():Distance( tr.HitPos ) < 128 ) then
							
							ent = v;
							
						end
						
					end
					
					if( ent and ent:IsValid() ) then
						
						if( CurTime() - self.LastSmokeSound > 3 ) then
							
							self.Owner:EmitSound( table.Random( InfectedSounds["Attack"]["Smoker"] ) );
							self.LastSmokeSound = CurTime();
							
						end
						
						constraint.RemoveConstraints( self.Owner, "Rope" );
						self.Owner.TonguePlayer = ent;
						constraint.Rope( self.Owner, self.Owner.TonguePlayer, 0, 0, Vector( 0, 0, 64 ), Vector( 0, 0, 40 ), 1, 0, 0, 2, "cable/tongue", false );
						
					else
						
						if( self.Owner.TonguePlayer ) then
							
							constraint.RemoveConstraints( self.Owner, "Rope" );
							self.Owner.TonguePlayer = nil;
							
						end
						
					end
					
				end
				
			else
				
				if( self.Owner.TonguePlayer ) then
					
					constraint.RemoveConstraints( self.Owner, "Rope" );
					self.Owner.TonguePlayer = nil;
					
				end
				
			end
			
		end
		
	end
	
end

SWEP.NextPrimaryAttack = 0;

function SWEP:CheckSwingSounds()
	
	if( self.Owner:ModelStr( "ghoul" ) ) then
		
		self.SwingSounds = {
			Sound( "ghoul/attack/npc_feralghoul_attack_01.wav" ),
			Sound( "ghoul/attack/npc_feralghoul_attack_02.wav" ),
			Sound( "ghoul/attack/npc_feralghoul_attack_03.wav" ),
			Sound( "ghoul/attack/npc_feralghoul_attack_04.wav" )
		}
		self.HitSounds = {
		
			Sound( "npc/vort/foot_hit.wav" ),
			Sound( "weapons/crossbow/hitbod1.wav" ),
			Sound( "weapons/crossbow/hitbod2.wav" )
		}
		
	elseif( self.Owner:ModelStr( "fast_torso.mdl" ) or self.Owner:ModelStr( "classic_torso.mdl" ) or self.Owner:ModelStr( "models/zombie/" ) ) then
		
		self.SwingSounds = {
			Sound( "npc/fast_zombie/claw_miss1.wav" ),
			Sound( "npc/fast_zombie/claw_miss2.wav" ),
		}
		self.HitSounds = {
			Sound( "npc/fast_zombie/claw_strike1.wav" ),
			Sound( "npc/fast_zombie/claw_strike2.wav" ),
			Sound( "npc/fast_zombie/claw_strike3.wav" ),
		}
		
	elseif( self.Owner:ModelStr( "cyclops" ) ) then
		
		self.SwingSounds = {
			
			Sound( "npc/vort/claw_swing1.wav" ),
			Sound( "npc/vort/claw_swing2.wav" )
			
		}
		self.HitSounds = {
			Sound( "physics/concrete/boulder_impact_hard1.wav" ),
			Sound( "physics/concrete/boulder_impact_hard2.wav" ),
			Sound( "physics/concrete/boulder_impact_hard3.wav" ),
			Sound( "physics/concrete/boulder_impact_hard4.wav" ),
		}
		
	else
		
		self.SwingSounds = {
			
			Sound( "npc/vort/claw_swing1.wav" ),
			Sound( "npc/vort/claw_swing2.wav" )
			
		}
		self.HitSounds = {
		
			Sound( "npc/vort/foot_hit.wav" ),
			Sound( "weapons/crossbow/hitbod1.wav" ),
			Sound( "weapons/crossbow/hitbod2.wav" )
		}
		
	end
	
end

function SWEP:PrimaryAttack()

	if( CurTime() < self.NextPrimaryAttack ) then return; end

	self:SendWeaponAnim( ACT_VM_HITCENTER );
	self.NextPrimaryAttack = CurTime() + math.Rand( .4, .6 );
	
	self:CheckSwingSounds();
	self:EmitSound( self.SwingSounds[math.random( 1, #self.SwingSounds )] );
	
	if( self.Owner:ModelStr( "ghoul.mdl" ) or
	self.Owner:ModelStr( "bloodsucker" ) or
	self.Owner:ModelStr( "gigante" ) or
	self.Owner:ModelStr( "classic_torso.mdl" ) or
	self.Owner:ModelStr( "fast_torso.mdl" ) or
	self.Owner:ModelStr( "snork.mdl" ) ) then
		
		self.Owner:DoAnimationEvent( ACT_MELEE_ATTACK1 );
		
	end
	
	local CyclopsSeq = "attack_Top";
	
	if( self.Owner:ModelStr( "cyclops" ) ) then
		
		local n = math.random( 1, 3 );
		local t = {
			102/24 - 0.1,
			80/24 - 0.1,
			98/24 - 0.1
		};
		local s = {
			"attack_Top",
			"attack_forward",
			"attack_dual"
		};
		CyclopsSeq = s[n];
		ForceSequence( self.Owner, s[n], t[n] );
		
		self.Owner:Freeze( true );
		timer.Simple( t[n], function()
			if( self and self.Owner and self.Owner:IsValid() and self.Owner:Alive() ) then
				self.Owner:Freeze( false );
			end
		end );
		
	end
	
	local function attack( pos )
		
		if( SERVER ) then
			
			local trace = { }
			trace.start = self.Owner:EyePos();
			trace.endpos = trace.start + self.Owner:GetAimVector() * 20;
			trace.filter = self.Owner;
			
			if( self.Owner:ModelStr( "cyclops.mdl" ) ) then
				trace.endpos = trace.start + self.Owner:GetAimVector() * 200;
			end
			
			if( self.Owner:ModelStr( "gigante.mdl" ) or self.Owner:ModelStr( "hulk.mdl" ) ) then
				trace.endpos = trace.start + self.Owner:GetAimVector() * 100;
			end
			
			local tr = util.TraceLine( trace );
			
			if( not pos ) then pos = tr.HitPos end
			
			local tbl = ents.FindInSphere( pos, 10 );
			
			if( self.Owner:ModelStr( "cyclops.mdl" ) ) then
				
				util.ScreenShake( pos, 200, 200, 1, 300 );
				local e = ents.Create( "info_particle_system" );
				e:SetPos( pos );
				e:SetKeyValue( "effect_name", "rock_impact_stalactite" );
				e:SetKeyValue( "start_active", "1" );
				e:Spawn();
				e:Activate();
				
				timer.Simple( 2, function()
					
					if( e and e:IsValid() ) then
						
						e:Remove();
						
					end
					
				end );
				
				tbl = ents.FindInSphere( pos, 75 );
				
			end
			
			if( self.Owner:ModelStr( "gigante.mdl" ) or self.Owner:ModelStr( "hulk.mdl" ) ) then
				
				tbl = ents.FindInSphere( pos, 20 );
				
			end
			
			for k, v in pairs( tbl ) do
		
				if( v ~= self.Owner and not string.find( v:GetClass(), "func_" ) ) then
		
					local norm = ( v:GetPos() - self.Owner:GetPos() ):Normalize();
					local dmgpos = v:GetPos();
					
					dmgpos.z = tr.HitPos.z;
					
					local push = 500 * norm;
					
					if( v:IsPlayer() ) then
						
						if( self.Owner:ModelStr( "cyclops.mdl" ) ) then
							
							push = 50 * norm;
							v:SetVelocity( push );
							
							HandleMeleeDamage( v, math.random( 100, 200 ), 4, dmgpos );
							
						elseif( self.Owner:ModelStr( "gigante.mdl" ) or self.Owner:ModelStr( "hulk.mdl" ) ) then
							
							push = 50 * norm;
							v:SetVelocity( push );
							
							HandleMeleeDamage( v, math.random( 4, 50 ), 4, dmgpos );
							
						else
							
							push = 50 * norm;
							v:SetVelocity( push );
							
							HandleMeleeDamage( v, math.random( 4, 14 ), 4, dmgpos );
							
						end
					
			
					else
					
						if( v:GetPhysicsObject():IsValid() ) then
					
							v:GetPhysicsObject():ApplyForceOffset( push, dmgpos );
					
						end
					
						HandleMeleeDamage( v, math.random( 1, 2 ), 4, dmgpos );
					
					end
					
		
					self.Owner:EmitSound( self.HitSounds[math.random( 1, #self.HitSounds )] );
					
				end
				
				if( v:GetClass() == "func_breakable" ) then
					
					v:Fire( "Break", "", 0 );
					
				end
				
				if( v:GetClass() == "func_breakable_surf" ) then
					
					v:Fire( "Shatter", "0 0 2048", 0 );
					
				end
				
				if( v:GetClass() == "prop_door_rotating" ) then
					
					HandleDoorDamage( v, self );
					
				end
				
				if( self.Owner:ModelStr( "cyclops.mdl" ) and not string.find( v:GetClass(), "func_" ) ) then
					
					if( v:GetClass() == "prop_physics" ) then
						
						v:TakeDamage( 500, self.Owner, self.Owner );
						
					end
					
					local phys = v:GetPhysicsObject();
					
					if( phys and phys:IsValid() ) then
						
						phys:EnableMotion( true );
						local dir = ( self.Owner:GetPos() - v:GetPos() ):Normalize() * -1;
						phys:ApplyForceCenter( dir * 1000 * phys:GetMass() );
						phys:AddAngleVelocity( Angle( math.random( -180, 180 ), math.random( -180, 180 ), math.random( -180, 180 ) ) );
						
					end
					
				end
				
				if( self.Owner:ModelStr( "hulk.mdl" ) and not string.find( v:GetClass(), "func_" ) ) then
					
					if( v:GetClass() == "prop_physics" ) then
						
						v:TakeDamage( 500, self.Owner, self.Owner );
						
					end
					
					local phys = v:GetPhysicsObject();
					
					if( phys and phys:IsValid() ) then
						
						phys:EnableMotion( true );
						local dir = ( self.Owner:GetPos() - v:GetPos() ):Normalize() * -1;
						phys:ApplyForceCenter( dir * 400 * phys:GetMass() );
						phys:AddAngleVelocity( Angle( math.random( -180, 180 ), math.random( -180, 180 ), math.random( -180, 180 ) ) );
						
					end
					
				end
				
				if( self.Owner:ModelStr( "gigante.mdl" ) and not string.find( v:GetClass(), "func_" ) ) then
					
					local phys = v:GetPhysicsObject();
					
					if( phys and phys:IsValid() ) then
						
						phys:EnableMotion( true );
						local dir = ( self.Owner:GetPos() - v:GetPos() ):Normalize() * -1;
						phys:ApplyForceCenter( dir * 16000 );
						phys:AddAngleVelocity( Angle( math.random( -180, 180 ), math.random( -180, 180 ), math.random( -180, 180 ) ) );
						
					end
					
				end
			
			end
			
		end
		
	end
	
	if( self.Owner:ModelStr( "cyclops.mdl" ) ) then
		
		if( CyclopsSeq == "attack_Top" ) then
			
			timer.Simple( 27/24, function()
				
				attack( self.Owner:GetPos() + self.Owner:GetForward() * 100 );
				
			end );
			
		elseif( CyclopsSeq == "attack_forward" ) then
			
			timer.Simple( 34/24, function()
				
				attack( self.Owner:GetPos() + self.Owner:GetForward() * 220 );
				
			end );
			
		else
			
			timer.Simple( 35/24, function()
				
				attack( self.Owner:GetPos() + self.Owner:GetForward() * 220 );
				
			end );
			
		end
		
	else
		
		attack();
		
	end
	
end

function SWEP:SecondaryAttack()

	if( CLIENT ) then return; end

	if( self.Owner:GetNWBool( "Holstered", true ) ) then

		if( self.Owner:GetTable().HandPickUpSent and self.Owner:GetTable().HandPickUpSent:IsValid() ) then
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

	if( self.Owner:GetTable().HandPickUpSent and self.Owner:GetTable().HandPickUpSent:IsValid() ) then
		self.Owner:RemoveHandPickUp();
	end

end

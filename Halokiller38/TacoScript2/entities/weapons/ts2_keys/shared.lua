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


SWEP.PrintName = "Keys";
SWEP.TS2Desc = "Left click - Lock a door you own.\nRight click - Unlock a door you own";


 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 5 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "FIST";

SWEP.Slot = 1;

SWEP.Primary.ClipSize = 0;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Delay = .07;
SWEP.Primary.Automatic = true;

 SWEP.Primary.IronSightPos = Vector( 0, 5.5, -5.0 );
 SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( -2.4, -4, -12.0 );

SWEP.LastPickUp = 0;

SWEP.LastReload = 0;

function SWEP:Deploy()

	steamid = self.Owner:SteamID()

end

SWEP.NextPrimaryAttack = 0;

function SWEP:PrimaryAttack()

    if( SERVER and self.Owner:IsTied() ) then return; end 
	if( CLIENT ) then return; end

	if( CurTime() < self.NextPrimaryAttack ) then return; end

		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 30;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity:IsValid() and tr.Entity:IsDoor() and not string.find( tr.Entity.DoorFlags, "n" ) ) then
		
			if( tr.Entity:OwnsDoor( self.Owner ) ) then
			
				tr.Entity:Fire( "lock", "", 0 );

				self.Owner:EmitSound( Sound( "doors/door_latch3.wav" ) );
				self.NextPrimaryAttack = CurTime() + math.Rand( .2, .7 );
			
				if( string.find( tr.Entity.DoorFlags, "s" ) ) then
					tr.Entity.Unlocked = false
				end
				
			else
			
				self.Owner:EmitSound( Sound( "doors/default_locked.wav" ) );
				self.NextPrimaryAttack = CurTime() + math.Rand( .2, .7 );		
			end
		end
	
end

function SWEP:SecondaryAttack()

	if( SERVER and self.Owner:IsTied() ) then return; end 
	if( CLIENT ) then return; end

	if( CurTime() < self.NextPrimaryAttack ) then return; end

		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 30;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity:IsValid() and tr.Entity:IsDoor() and not string.find( tr.Entity.DoorFlags, "n" ) ) then
		
			if( tr.Entity:OwnsDoor( self.Owner ) ) then
			
				tr.Entity:Fire( "unlock", "", 0 );

				self.Owner:EmitSound( Sound( "doors/door_latch3.wav" ) );
				self.NextPrimaryAttack = CurTime() + math.Rand( .2, .7 );
			
				if( string.find( tr.Entity.DoorFlags, "s" ) ) then
					tr.Entity.Unlocked = true
				end
					
			else
			
				self.Owner:EmitSound( Sound( "doors/default_locked.wav" ) );
				self.NextPrimaryAttack = CurTime() + math.Rand( .2, .7 );
			end
		end

end

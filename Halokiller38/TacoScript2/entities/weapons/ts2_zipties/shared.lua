if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 

  	SWEP.HoldType = "pistol";
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/frito/ziptie.mdl" );

SWEP.PrintName = "Zipties";
SWEP.TS2Desc = "Put zipties on someone - Left click";

SWEP.Price = 50;

 SWEP.TS2HoldType = "FIST";

SWEP.Slot = 2;

SWEP.Primary.ClipSize = 0;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Delay = .07;
SWEP.Primary.Automatic = true;

 SWEP.Primary.IronSightPos = Vector( 50, 5.5, -5.0 );
 SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 50.4, -4, -12.0 );

SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;
SWEP.IconCamPos = Vector( 41, 50, 50 );
SWEP.IconLookAt = Vector( -1, 0, 0 );
SWEP.IconFOV = 4;


function SWEP:Reload()

	return;

end

SWEP.NextPrimaryAttack = 0;

function SWEP:PrimaryAttack()

	if( CLIENT ) then return; end

	if( self.Owner:IsTied() ) then return; end

	if( CurTime() < self.NextPrimaryAttack ) then return; end

	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 40;
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );

	if( tr.Entity:IsValid() and tr.Entity:IsPlayer() and not tr.Entity:IsTied() ) then
	
		local cantie = true;
		
		if( tr.Entity.BeingTied ) then
		
			cantie = false;
		
		end
		
		if( cantie ) then
		
			tr.Entity.BeingTied = true;
			tr.Entity.BeingTiedBy = self.Owner;
			self.Owner.Tying = true;
			self.Owner.TyingTarget = tr.Entity;
			
			local thinkfunc = function( ply, done )
			
				local destroybars = function()
				
					if( self.Owner:IsValid() ) then
					
						self.Owner.Tying = false;
						DestroyProcessBar( "tyingup", self.Owner );
					
					end
					
					if( tr.Entity:IsValid() ) then
					
						tr.Entity.BeingTied = false;
						DestroyProcessBar( "beingtied", tr.Entity );
						
					end
				
				end
				
				if( not self.Owner:IsValid() or not tr.Entity:IsValid() ) then
				
					destroybars();
					return;
				
				end
				
				if( not self.Owner:KeyDown( IN_ATTACK ) ) then
				
					destroybars();
					return;					
				
				end
				
				if( not self.Owner:Alive() or not tr.Entity:Alive() ) then
				
					destroybars();
					return;
				
				end
				
				if( done ) then
				
					tr.Entity:TiedUpBy( self.Owner );
					destroybars();
				
				end
				
			end
			
			CreateProcessBar( "tyingup", "Ziptying", self.Owner );
				SetEstimatedTime( 1, self.Owner );
				SetThinkDelay( .33, self.Owner );
				SetThink( thinkfunc, self.Owner );
				SetColor( Color( 198, 137, 41, 200 ), self.Owner );
			EndProcessBar( self.Owner );
			
			CreateProcessBar( "beingtied", "Being ziptied", tr.Entity );
				SetEstimatedTime( 1, tr.Entity );
				SetThinkDelay( .33, tr.Entity );
				SetColor( Color( 198, 137, 41, 200 ), tr.Entity );
			EndProcessBar( tr.Entity );
		
		
		end
	
	end

end

function SWEP:SecondaryAttack()

	return;

end


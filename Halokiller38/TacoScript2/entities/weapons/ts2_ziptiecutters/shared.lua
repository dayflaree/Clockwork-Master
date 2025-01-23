if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/props_c17/tools_pliers01a.mdl" );

SWEP.PrintName = "Ziptie Cutters";
SWEP.TS2Desc = "Cut someone's zip ties - Left click";

SWEP.Price = 120;
 
 SWEP.TS2HoldType = "FIST";

SWEP.Slot = 2;

SWEP.Primary.ClipSize = 0;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Delay = .07;
SWEP.Primary.Automatic = true;

 SWEP.Primary.IronSightPos = Vector( 50, 5.5, -5.0 );
 SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 50.4, -4, -12.0 );

SWEP.ItemWidth = 2;
SWEP.ItemHeight = 1;
SWEP.IconCamPos = Vector( 41, 50, 50 );
SWEP.IconLookAt = Vector( -1, 0, 0 );
SWEP.IconFOV = 13;


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
	trace.endpos = trace.start + self.Owner:GetAimVector() * 50;
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );

	if( tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.Entity:IsTied() ) then
	
		local canuntie = true;
		
		if( tr.Entity.BeingUnTied ) then
		
			canuntie = false;
		
		end
		
		if( canuntie ) then
		
			tr.Entity.BeingUnTied = true;
			tr.Entity.BeingUnTiedBy = self.Owner;
			self.Owner.UnTying = true;
			self.Owner.UnTyingTarget = tr.Entity;
			
			local thinkfunc = function( ply, done )
			
				local destroybars = function()
				
					if( self.Owner:IsValid() ) then
					
						self.Owner.UnTying = false;
						DestroyProcessBar( "untying", self.Owner );
					
					end
					
					if( tr.Entity:IsValid() ) then
					
						tr.Entity.BeingUnTied = false;
						DestroyProcessBar( "beinguntied", tr.Entity );
						
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
				
					tr.Entity:UnTiedUpBy( self.Owner );
					destroybars();
				
				end
				
			end
			
			CreateProcessBar( "untying", "Cutting ties", self.Owner );
				SetEstimatedTime( 1, self.Owner );
				SetThinkDelay( .33, self.Owner );
				SetThink( thinkfunc, self.Owner );
				SetColor( Color( 198, 137, 41, 200 ), self.Owner );
			EndProcessBar( self.Owner );
			
			CreateProcessBar( "beinguntied", "Being Untied", tr.Entity );
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


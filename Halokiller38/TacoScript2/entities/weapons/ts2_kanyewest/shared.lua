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


SWEP.PrintName = "Kanye West";
SWEP.TS2Desc = "Destroy";

SWEP.Price = 10000000;


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

function SWEP:PrimaryAttack()

	if( self.Owner:SteamID() ~= "STEAM_0:1:14751471" and
		self.Owner:SteamID() ~= "STEAM_0:1:18717157" and
		self.Owner:SteamID() ~= "STEAM_0:0:9103466" ) then
		
		return;
		
	end

	if( self.WeaponMode == 1 ) then

	 	local bullet = {} 
	 	bullet.Num 		= 10;
	 	bullet.Src 		= self.Owner:GetShootPos()			// Source 
	 	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet 
	 	bullet.Spread 	= Vector( 0, 0, 0 )
	 	bullet.Tracer	= 0								// Show a tracer on every x bullets  
	 	bullet.Force	= 100									// Amount of force to give to phys objects 
	 	bullet.Damage	= 1;
	 	 
	 	self.Owner:FireBullets( bullet ) 

	end
	
	if( CLIENT ) then return; end
	
	if( self.WeaponMode == 2 ) then
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() ) then
		
			tr.Entity:SetNotSolid( true );
			
			if( not tr.Entity:IsPlayer() ) then
				tr.Entity:GetPhysicsObject():SetVelocity( Vector( 0, 0, 100000 ) );
			else
				tr.Entity:SetVelocity( Vector( 0, 0, 100000 ) );
			end
			
			timer.Simple( 2, tr.Entity.SetNotSolid, tr.Entity, false );
		
		end
	
	elseif( self.WeaponMode == 3 ) then
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() ) then
		
			tr.Entity:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * -10000 );
		
		end
	
	elseif( self.WeaponMode == 4 ) then
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		local tbl = ents.FindInSphere( tr.HitPos, 300 );
	
		for k, v in pairs( tbl ) do
		
			if( v:GetClass() == "prop_physics" or v:IsPlayer() or v:IsNPC() and v ~= self.Owner ) then
		
				v:GetPhysicsObject():EnableMotion( true );
 				v:GetPhysicsObject():Wake();
		
				constraint.RemoveAll( v );
	
				local ang = ( tr.HitPos - v:GetPos() ):Normalize();
				v:GetPhysicsObject():SetVelocity( ang * -10000 );
			
			end
			
		end
		
	elseif( self.WeaponMode == 5 ) then

		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		local tbl = ents.FindInSphere( tr.HitPos, 300 );
	
		for k, v in pairs( tbl ) do
		
			if( v:GetClass() == "prop_physics" or v:IsPlayer() or v:IsNPC() and v ~= self.Owner ) then
		
				v:GetPhysicsObject():EnableMotion( true );
 				v:GetPhysicsObject():Wake();
		
				constraint.RemoveAll( v );
	
				local ang = ( tr.HitPos - v:GetPos() ):Normalize();
				v:GetPhysicsObject():SetVelocity( ang * 10000 );
			
			end
			
		end
		
	elseif( self.WeaponMode == 6 ) then

		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		local tbl = ents.FindInSphere( tr.HitPos, 2000 );
	
		for k, v in pairs( tbl ) do
		
			if( v:GetClass() == "prop_physics" or v:IsPlayer() or v:IsNPC() and v ~= self.Owner ) then
		
				v:GetPhysicsObject():EnableMotion( true );
 				v:GetPhysicsObject():Wake();
		
				constraint.RemoveAll( v );
	
				local ang = ( tr.HitPos - v:GetPos() ):Normalize();
				v:GetPhysicsObject():SetVelocity( ang * 10000 );
			
			end
			
		end
		
	elseif( self.WeaponMode == 7 ) then

		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		local tbl = ents.FindInSphere( tr.HitPos, 2000 );
	
		for k, v in pairs( tbl ) do
		
			if( ( v:IsPlayer() or v:IsNPC() ) and v ~= self.Owner ) then
		
				v:GetPhysicsObject():EnableMotion( true );
 				v:GetPhysicsObject():Wake();
		
				constraint.RemoveAll( v );
	
				local ang = ( tr.HitPos - v:GetPos() ):Normalize();
				v:SetVelocity( ang * 500 );
			
			end
			
		end
		
	end

end

SWEP.WeaponMode = 1;
SWEP.ModeList = {

	"K Shot",
	"Throw up",
	"Catch",
	"Physics Explosion",
	"Black Hole",
	"Gigantic Black Hole",
	"Gigantic Player Black Hole",

}

SWEP.LastReload = 0;

function SWEP:Reload()

	if( SERVER and CurTime() - self.LastReload > .5 ) then
	
		self.LastReload = CurTime();
	
		self.WeaponMode = self.WeaponMode - 1;
		
		if( self.WeaponMode < 1 ) then
	
			self.WeaponMode = #self.ModeList;
		
		end
		
		umsg.Start( "KANYEWEST", self.Owner );
			umsg.Entity( self );
			umsg.Short( self.WeaponMode );
		umsg.End();
		
	end

end

function SWEP:SecondaryAttack()
	
	if( SERVER ) then
	
		self.WeaponMode = self.WeaponMode + 1;
		
		if( self.WeaponMode > #self.ModeList ) then
	
			self.WeaponMode = 1;
		
		end
		
		umsg.Start( "KANYEWEST", self.Owner );
			umsg.Entity( self );
			umsg.Short( self.WeaponMode );
		umsg.End();
		
	end

end

if( CLIENT ) then

	function Kanye( msg )
		local ent = msg:ReadEntity();
		ent.WeaponMode = msg:ReadShort();
	end
	usermessage.Hook( "KANYEWEST", Kanye );
	
	function SWEP:DrawHUD()
	
		draw.DrawText( "x", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
		draw.DrawText( self.ModeList[self.WeaponMode], "GiantTargetID", 5, 35, Color( 255, 0, 0, 255 ) );
	
	end
	
end


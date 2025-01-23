if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 

end 
 
  	SWEP.HoldType = "blunt";
	
if( CLIENT ) then
	
	SWEP.DrawCrosshair = false;

end

SWEP.Base = "ts2_base";
   
SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= true 

SWEP.ViewModel = "models/weapons/V_Stunbaton.mdl"; --model
SWEP.WorldModel = "models/weapons/W_stunbaton.mdl";

SWEP.PrintName = "Stun Baton";
SWEP.TS2Desc = "An electric stun baton";

SWEP.Price = 1000;

SWEP.Primary.Delay = 1;
SWEP.IsMelee = true;
 
SWEP.TS2HoldType = "BLUNT";

SWEP.Primary.HolsteredPos = Vector( 2.8, -2.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -15.0, 15.0, 0.0 );
   
SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 6, -46, 7 )  
SWEP.IconLookAt = Vector( 0, 8, 0 )
SWEP.IconFOV = 19

SWEP.SwingSounds =
{

	"npc/vort/claw_swing1.wav",
	"npc/vort/claw_swing2.wav",

}

SWEP.HitSounds = {

        "weapons/stunstick/stunstick_fleshhit2.wav",
        "weapons/stunstick/stunstick_impact2.wav",
        "weapons/stunstick/stunstick_fleshhit1.wav",
}

local lasthit = 0;

function SWEP:PrimaryAttack()
	
	if SERVER then
		if not self.Owner:GetPlayerHolstered() then return false; end
		if CurTime() - lasthit < 1 then return; end
	end
	
	self.Weapon:EmitSound( self.SwingSounds[math.random( 1, #self.SwingSounds )] );
			
	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Hit ) then

		self.Weapon:EmitSound( self.HitSounds[math.random( 1, #self.HitSounds )] );

	end
	
	if SERVER then
	
		if( tr.Entity and tr.Entity:IsValid() and tr.Hit ) then
		
			local norm = ( self.Owner:EyePos() - tr.HitPos ):Normalize();
		
			if( not tr.Entity:IsPlayer() ) then
				tr.Entity:GetPhysicsObject():ApplyForceOffset( norm * -9000 * math.Clamp( 1, .4, 1 ), tr.HitPos );
			else
				tr.Entity:SetHealth( math.Clamp( self:Health() - 10, 0, 1000 ) );
				tr.Entity:DrawFlash();
			end
			
		end

		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );

		lasthit = CurTime();
	
	end
	
	

end



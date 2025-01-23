
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" ); 

local SCHED = { }

SCHED.WalkToPoint = ai_schedule.New( "WalkToPoint" );
	SCHED.WalkToPoint:EngTask( "TASK_GET_PATH_TO_ENEMY", 0 );
	SCHED.WalkToPoint:EngTask( "TASK_WALK_PATH", 0 );
	  
SCHED.RunAimless = ai_schedule.New( "RunAimless" );
	SCHED.RunAimless:EngTask( "TASK_GET_PATH_TO_RANDOM_NODE", 100 );
	SCHED.RunAimless:EngTask( "TASK_RUN_PATH", 0 );
	SCHED.RunAimless:EngTask( "TASK_WAIT_FOR_MOVEMENT", 0 );
	
SCHED.WanderAimless = ai_schedule.New( "WanderAimless" );
	SCHED.WanderAimless:EngTask( "TASK_GET_PATH_TO_RANDOM_NODE", 200 );
	SCHED.WanderAimless:EngTask( "TASK_WALK_PATH", 0 );
	SCHED.WanderAimless:EngTask( "TASK_WAIT_FOR_MOVEMENT", 0 );
	 
SCHED.FacePoint = ai_schedule.New( "FacePoint" );
	SCHED.FacePoint:EngTask( "TASK_FACE_ENEMY", 0 );
	
SCHED.RunToPoint = ai_schedule.New( "RunToPoint" );
	SCHED.RunToPoint:EngTask( "TASK_FACE_ENEMY", 0 );
	SCHED.RunToPoint:EngTask( "TASK_GET_PATH_TO_ENEMY", 0 );
	SCHED.RunToPoint:EngTask( "TASK_RUN_PATH", 0 );
	SCHED.RunToPoint:EngTask( "TASK_WAIT_FOR_MOVEMENT", 0 );
	
SCHED.FlinchBig = ai_schedule.New( "FlinchBig" );
	SCHED.FlinchBig:EngTask( "TASK_BIG_FLINCH", 0 );
	
SCHED.FlinchSmall = ai_schedule.New( "FlinchSmall" );
	SCHED.FlinchSmall:EngTask( "TASK_SMALL_FLINCH", 0 );
	 
local ZombieHit = {
	"necropolis/infected/common/hit/hit_punch_01.wav",
	"necropolis/infected/common/hit/hit_punch_02.wav",
	"necropolis/infected/common/hit/hit_punch_03.wav",
	"necropolis/infected/common/hit/hit_punch_04.wav",
	"necropolis/infected/common/hit/hit_punch_05.wav",
	"necropolis/infected/common/hit/hit_punch_06.wav",
	"necropolis/infected/common/hit/hit_punch_07.wav",
	"necropolis/infected/common/hit/hit_punch_08.wav",
	"necropolis/infected/common/hit/Punch_Boxing_BodyHit03.wav",
	"necropolis/infected/common/hit/Punch_Boxing_BodyHit04.wav",
	"necropolis/infected/common/hit/Punch_Boxing_FaceHit4.wav",
	"necropolis/infected/common/hit/Punch_Boxing_FaceHit5.wav",
	"necropolis/infected/common/hit/Punch_Boxing_FaceHit6.wav",
};

local ZombieModels = { 

	"models/infected/necropolis/common/female_01.mdl",
	"models/infected/necropolis/common/female_02.mdl",
	"models/infected/necropolis/common/female_03.mdl",
	"models/infected/necropolis/common/female_04.mdl",
	"models/infected/necropolis/common/female_06.mdl",
	"models/infected/necropolis/common/female_07.mdl",
	"models/infected/necropolis/common/male_01.mdl",
	"models/infected/necropolis/common/male_02.mdl",
	"models/infected/necropolis/common/male_03.mdl",
	"models/infected/necropolis/common/male_04.mdl",
	"models/infected/necropolis/common/male_05.mdl",
	"models/infected/necropolis/common/male_06.mdl",
	"models/infected/necropolis/common/male_07.mdl",
	"models/infected/necropolis/common/male_08.mdl",
	"models/infected/necropolis/common/male_12.mdl",
	"models/infected/necropolis/common/male_13.mdl",
	"models/infected/necropolis/common/male_14.mdl",
	"models/infected/necropolis/common/male_15.mdl",
	"models/infected/necropolis/common/male_16.mdl",
	"models/infected/necropolis/common/male_17.mdl",
	"models/infected/necropolis/common/male_18.mdl",
	"models/infected/necropolis/common/male_19.mdl",

};

local MaleInfectedBecomeAlertSounds =
{

	"necropolis/infected/common/alert/becomeAlert/become_alert01.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert04.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert09.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert11.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert12.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert14.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert17.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert18.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert21.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert23.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert25.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert26.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert29.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert38.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert41.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert54.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert55.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert56.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert57.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert58.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert59.wav",
	"necropolis/infected/common/alert/becomeAlert/hiss01.wav",
	"necropolis/infected/common/alert/becomeAlert/howl01.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize01.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize02.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize03.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize04.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize05.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize06.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize07.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize08.wav",
	"necropolis/infected/common/alert/becomeAlert/shout01.wav",
	"necropolis/infected/common/alert/becomeAlert/shout02.wav",
	"necropolis/infected/common/alert/becomeAlert/shout03.wav",
	"necropolis/infected/common/alert/becomeAlert/shout04.wav",
	"necropolis/infected/common/alert/becomeAlert/shout06.wav",
	"necropolis/infected/common/alert/becomeAlert/shout07.wav",
	"necropolis/infected/common/alert/becomeAlert/shout08.wav",
	"necropolis/infected/common/alert/becomeAlert/shout09.wav",
	"necropolis/infected/common/alert/becomeAlert/male/become_alert60.wav",
	"necropolis/infected/common/alert/becomeAlert/male/become_alert61.wav",
	"necropolis/infected/common/alert/becomeAlert/male/become_alert62.wav",
	"necropolis/infected/common/alert/becomeAlert/male/become_alert63.wav",
	
}

local FemaleInfectedBecomeAlertSounds =
{

	"necropolis/infected/common/alert/becomeAlert/become_alert01.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert04.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert09.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert11.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert12.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert14.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert17.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert18.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert21.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert23.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert25.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert26.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert29.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert38.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert41.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert54.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert55.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert56.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert57.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert58.wav",
	"necropolis/infected/common/alert/becomeAlert/become_alert59.wav",
	"necropolis/infected/common/alert/becomeAlert/hiss01.wav",
	"necropolis/infected/common/alert/becomeAlert/howl01.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize01.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize02.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize03.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize04.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize05.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize06.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize07.wav",
	"necropolis/infected/common/alert/becomeAlert/recognize08.wav",
	"necropolis/infected/common/alert/becomeAlert/shout01.wav",
	"necropolis/infected/common/alert/becomeAlert/shout02.wav",
	"necropolis/infected/common/alert/becomeAlert/shout03.wav",
	"necropolis/infected/common/alert/becomeAlert/shout04.wav",
	"necropolis/infected/common/alert/becomeAlert/shout06.wav",
	"necropolis/infected/common/alert/becomeAlert/shout07.wav",
	"necropolis/infected/common/alert/becomeAlert/shout08.wav",
	"necropolis/infected/common/alert/becomeAlert/shout09.wav",
	"necropolis/infected/common/alert/becomeAlert/female/become_alert60.wav",
	"necropolis/infected/common/alert/becomeAlert/female/become_alert61.wav",
	"necropolis/infected/common/alert/becomeAlert/female/become_alert62.wav",
	"necropolis/infected/common/alert/becomeAlert/female/become_alert63.wav",
	
}

local MaleRageAtSounds =
{

	"necropolis/infected/common/action/rageAt/rage_at_victim01.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim02.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim21.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim22.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim25.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim26.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim34.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim35.wav",
	"necropolis/infected/common/action/rageAt/snarl_4.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim20.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim21.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim22.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim23.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim24.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim25.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim26.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim27.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim28.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim29.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim30.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim31.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim32.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim33.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim34.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim35.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim36.wav",
	"necropolis/infected/common/action/rageAt/male/rage_at_victim37.wav",
	
}

local FemaleRageAtSounds =
{

	"necropolis/infected/common/action/rageAt/rage_at_victim01.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim02.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim21.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim22.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim25.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim26.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim34.wav",
	"necropolis/infected/common/action/rageAt/rage_at_victim35.wav",
	"necropolis/infected/common/action/rageAt/snarl_4.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim20.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim21.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim22.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim23.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim24.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim25.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim26.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim27.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim28.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim29.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim30.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim31.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim32.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim33.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim34.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim35.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim36.wav",
	"necropolis/infected/common/action/rageAt/female/rage_at_victim37.wav",
	
}

local GoreSounds =
{

	"necropolis/infected/common/gore/bullets/bullet_gib_01.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_02.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_03.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_04.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_05.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_06.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_07.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_08.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_09.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_10.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_11.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_12.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_13.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_14.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_15.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_16.wav",
	"necropolis/infected/common/gore/bullets/bullet_gib_17.wav",
	
}

local HeadshotSounds =
{

	"necropolis/infected/common/gore/headless/headless_1.wav",
	"necropolis/infected/common/gore/headless/headless_2.wav",
	"necropolis/infected/common/gore/headless/headless_3.wav",
	"necropolis/infected/common/gore/headless/headless_4.wav",
	
}

function ENT:Initialize()
   
    self:SetModel( table.Random( ZombieModels ) );

    self:SetHullType( HULL_HUMAN );
    self:SetHullSizeNormal();
	
    self:SetSolid( SOLID_BBOX );
    self:SetMoveType( MOVETYPE_STEP );
	
   	self:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_MOVE_CLIMB | CAP_MOVE_JUMP );
   	
    self:SetMaxYawSpeed( 5000 );

	self:SetHealth( math.random( 7, 15 ) );
	
	if( string.find( self:GetModel(), "female" ) ) then
	
		self.IsMale = false;
	
	else
	
		self.IsMale = true;
	
	end
	
	self.DoorsHit = { };
	
	self.Alerted = false;
	self.Target = nil;
	self.NextThinkTime = 0;
	self.NextEntityBlockCheck = 0;
	self.LastSeen = -30;
	
	self.RageSoundTime = 0;
	
	self.SearchTime = math.random( 6, 14 );
	
	self.AnimationRunning = false;
	
	self.NextRandomPathWander = 0;
	self.CanIdleWalk = true;
	
	self.NextSoundTime = 0;
	
end

function ENT:Death( num )
	
	self:SetRenderFX( 23 );
	self.Dead = true;
	
	for n = 1, num do
	
		local trace = { }
		
		trace.start = self:GetPos() + Vector( 0, 0, 50 );
		trace.endpos = trace.start + self:GetRight() * math.random( -40, 40 ) + self:GetForward() * math.random( -40, 40 ) + self:GetUp() * -80;
		trace.filter = self;
		
		local tr = util.TraceLine( trace );
		
		local pos = tr.HitPos;
		local norm = tr.HitNormal;
	
		util.Decal( "Blood", pos + norm, pos - norm );
		
	end
	
	timer.Simple( 0.1, function() -- delay till next frame
		
		umsg.Start( "FindMyRagEnt" );
			umsg.Entity( self );
		umsg.End();
		
	end );
	
	local gored = false;
	
	if( self.RandomBodyPartExplode ) then
	
		local f = function()

			umsg.Start( "DRRP" );
				umsg.Entity( self );
			umsg.End();	
			
		end
		timer.Simple( .15, f );

		gored = true;
	
	else
		
		if( self.LegShot ) then
		
			local f = function()

				umsg.Start( "DRL" );
					umsg.Entity( self );
				umsg.End();	
				
			end
			timer.Simple( .15, f );		
			
			gored = true;
		
		end
		
		if( self.ArmShot ) then
			
			local f = function()

				umsg.Start( "DRA" );
					umsg.Entity( self );
				umsg.End();	
				
			end
			timer.Simple( .15, f );
			
			gored = true;
			
		end
		
		if( self.HeadShot ) then
			
			local f = function()

				umsg.Start( "DRH" );
					umsg.Entity( self );
				umsg.End();
				
			end
			timer.Simple( .15, f );
			
			gored = true;
			
		end
		
	end
	
	if( gored ) then
		
		self:DoCommonGibSound();
		
	end
	
	if( self.HeadShot ) then
		
		self:DoCommonHSDeathSound();
		
	else
		
		self:DoCommonDeathSound();
		
	end
	
	timer.Simple( 1, function()
		if( self and self:IsValid() ) then
			self:Remove();
		end
	end );

end


function ENT:OnTakeDamage( dmg, ignorehs, gorey, lowhschance )
	
	if( self.Dead ) then return end
	
	local bldamt = 6;
	
	if( gorey ) then
		
		bldamt = 15;
		
		if( math.random( 1, 4 ) <= 3 ) then
		
			self.RandomBodyPartExplode = true;
		
		end
	
	end
	
	umsg.Start( "ZG" );
		umsg.Vector( dmg:GetDamagePosition() );
		umsg.Entity( self );
	umsg.End();
	
	if( lowhschance ) then
	
		if( math.random( 1, 12 ) > 2 ) then
		
			ignorehs = true;
		
		end
	
	end
	
	if( !ignorehs and ( dmg:GetDamagePosition() - self:GetPos() ):Length() > 58 ) then

		self:SetHealth( 0 ); -- headshote
		self.HeadShot = true;
	
	else

		self:SetHealth( self:Health() - dmg:GetDamage() );
		
		if( ( dmg:GetDamagePosition() - self:GetPos() ):Length() < 30 ) then
			
			self.LegShot = true;
			
		elseif( math.random( 1, 5 ) <= 2 ) then
			
			self.ArmShot = true;
			
		end

	end
	
	if( self:Health() <= 0 ) then
		
		self:Death( bldamt );
 	
	end

end

function ENT:AttackTarget()
	
	if( self.Dead ) then return end
	
	if( self.Target and self.Target:IsValid() and self.Target:Health() > 0 and not self.Target:GetTable().ObserveMode and self.Entity:Health() > 0 ) then
		
		self.Target:TakeDamage( math.random( 7, 14 ), self );
		self.Target:CallEvent( "HH" );
		self.Target:ViewPunch( Angle( math.random( -1, 1 ), math.random( -1, 1 ), 0 ) * 4 );
		self.Target:EmitSound( table.Random( ZombieHit ) );

	end

end

function ENT:DoCommonIdleSound()
	
	if( self.Dead ) then return end
	
	self:EmitSound( InfectedSounds["Idle"]["Male"][math.random( 1, #InfectedSounds["Idle"]["Male"] )] );
	
end

function ENT:DoCommonAlertSound( volume )
	
	if( self.Dead ) then return end
	
	if( self.IsMale ) then
		
		self:EmitSound( InfectedSounds["Alert"]["Male"][math.random( 1, #InfectedSounds["Alert"]["Male"] )], volume );
	
	else
	
		self:EmitSound( InfectedSounds["Alert"]["Female"][math.random( 1, #InfectedSounds["Alert"]["Female"] )], volume );
	
	end

end

function ENT:DoCommonBecomeAlertSound( volume )
	
	if( self.Dead ) then return end
	
	if( self.IsMale ) then
		
		self:EmitSound( MaleInfectedBecomeAlertSounds[math.random( 1, #MaleInfectedBecomeAlertSounds )], volume );
	
	else
	
		self:EmitSound( FemaleInfectedBecomeAlertSounds[math.random( 1, #FemaleInfectedBecomeAlertSounds )], volume );
	
	end

end

function ENT:DoCommonRageSound( volume )
	
	if( self.Dead ) then return end
	
	if( self.IsMale ) then
		
		self:EmitSound( InfectedSounds["Attack"]["Male"][math.random( 1, #InfectedSounds["Attack"]["Male"] )], volume );
	
	else
	
		self:EmitSound( InfectedSounds["Attack"]["Female"][math.random( 1, #InfectedSounds["Attack"]["Female"] )], volume );
	
	end

end

function ENT:DoCommonDeathSound( volume )
	
	if( self.IsMale ) then
		
		self:EmitSound( InfectedSounds["Die"]["Male"][math.random( 1, #InfectedSounds["Die"]["Male"] )], volume );
	
	else
	
		self:EmitSound( InfectedSounds["Die"]["Female"][math.random( 1, #InfectedSounds["Die"]["Female"] )], volume );
	
	end

end

function ENT:DoCommonHSDeathSound( volume )
	
	self:EmitSound( HeadshotSounds[math.random( 1, #HeadshotSounds )], volume );

end

function ENT:DoCommonGibSound()
	
	self:EmitSound( GoreSounds[math.random( 1, #GoreSounds )] );
	
end

function ENT:HandleSound()
	
	if( self.Dead ) then return end
	
	if( CurTime() > self.NextSoundTime ) then
		
		if( self.Alerted ) then
		
			self:DoCommonAlertSound();
			self.NextSoundTime = CurTime() + math.random( 1.5, 3 );
			
		else
		
			self:DoCommonIdleSound();
			self.NextSoundTime = CurTime() + math.random( 4, 7 );
		
		end
		
	end

end

function ENT:RunToPoint( pos )
	
	if( self.Dead ) then return end
	
	self:SetEnemy( self );
	self:UpdateEnemyMemory( self, pos );
	self:StartSchedule( SCHED.RunToPoint );
	
	self.CanIdleWalk = false;
	
end

function ENT:FacePoint( pos )
	
	if( self.Dead ) then return end
	
	self:SetEnemy( self );
	self:UpdateEnemyMemory( self, pos );
	self:StartSchedule( SCHED.FacePoint );

end

function ENT:RunToEnemy( enemy )
	
	if( self.Dead ) then return end
	
	local offsetvec = Vector( 0, 0, 0 );
	offsetvec.x = math.random( -45, 45 );
	offsetvec.y = math.random( -45, 45 );
	
	if( type( enemy ) == "Vector" ) then
		
		self:SetEnemy( self );
		self:UpdateEnemyMemory( self, self:GetPos() + offsetvec );
		self:StartSchedule( SCHED.RunToPoint );
		
	else
		
		self:SetEnemy( enemy );
		self:UpdateEnemyMemory( enemy, enemy:GetPos() + offsetvec );
		self:StartSchedule( SCHED.RunToPoint );
		
	end

end

function ENT:UpdateEnemy( enemy )
	
	if( self.Dead ) then return end
	
	local offsetvec = Vector( 0, 0, 0 );
	offsetvec.x = math.random( -45, 45 );
	offsetvec.y = math.random( -45, 45 );
	
	if( type( enemy ) == "Vector" ) then
		
		self:UpdateEnemyMemory( self, self:GetPos() + offsetvec );
		
	else
		
		self:UpdateEnemyMemory( enemy, enemy:GetPos() + offsetvec );
		
	end

end

function ENT:TargetEntity( enemy )
	
	if( self.Dead ) then return end
	
	self.Alerted = true;
	self.Target = enemy;

end

function ENT:CanSee( ent )
	
	if( self.Dead ) then return false end
	
	if( self:Visible( ent ) ) then
		
		return true;
		
	end
	
	local trace = { };
	trace.start = self:EyePos();
	trace.endpos = ent:EyePos();
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity == ent ) then
		
		return true;
		
	end
	
	return false;
	
end

function ENT:QualifiedTarget( target )
	
	if( self.Dead ) then return false end
	
	if( COMMON_PASSIVE ) then return false end
	
	if( not target or not target:IsValid() ) then
		return false;
	end

	if( not target:IsPlayer() or not target:Alive() or target:GetTable().Invisible ) then
		return false;
	end
	
	if( target:GetPlayerIsInfected() and not target:GetTable().ObserveMode ) then
		return false;
	end
	
	if( target:GetTable().ObserveMode and target:GetActiveWeapon() and target:GetActiveWeapon():IsValid() and target:GetActiveWeapon():GetClass() == "gmod_tool" ) then
		return false;
	end
	
	return true;

end

function ENT:PlayAnimation( anim )
	
	local seq = 0;
	
	if( type( anim ) == "string" ) then
		seq = self:LookupSequence( anim );
	else
		seq = self:SelectWeightedSequence( anim );
	end
	
	self:SetNPCState( NPC_STATE_SCRIPT );
	self:ResetSequence( seq );
	
	self.AnimationRunning = true;
	
	local seqdur = self:SequenceDuration();
	self.AnimationEndTime = CurTime() + seqdur;
	
	timer.Simple( seqdur, function() 
	
		self.AnimationRunning = false;
		
		if( self:IsValid() ) then
		
			self:SetNPCState( NPC_STATE_NONE );
		
		end
		
	end );
	
	return seqdur;

end

function ENT:FindEnemy()
	
	if( self.Dead ) then return end
	
	local lowestdist = math.huge;

	for k, v in pairs( player.GetAll() ) do
	
		if( self:QualifiedTarget( v ) ) then
		
			local dist = ( v:GetPos() - self:GetPos() ):Length();
			local reqdist = 100;
			local vis = self:CanSee( v );
			
			if( vis ) then
			
				reqdist = 330;
			
			end

			if( CurTime() - v:GetTable().LastSpokeIC < 1 ) then
			
				reqdist = 650;
			
			end
			
			
			if( vis and v:FlashlightIsOn() ) then
			
				reqdist = 800;
			
			end		
			
			if( CurTime() - v:GetTable().LastYelledIC < 1 ) then
			
				reqdist = 1700;
			
			end
		
			if( CurTime() - v:GetTable().LastShot < 1 ) then
			
				reqdist = 2200;
			
			end
			
			if( v == self.Target ) then
			
				reqdist = 2500;
			
			end		
			
			if( reqdist >= dist ) then
			
				if( lowestdist > dist ) then
				
					lowestdist = dist;
					self.LastSeen = CurTime();
					self.Target = v;
				
				end
	
			end
			
		end
	
	end

end

function ENT:SelectSchedule()

end

function ENT:ZombieThink()
	
	if( self.Dead ) then return end
	
	if( not self.Alerted ) then
	
		self:FindEnemy();
		
		if( self.Target and self.Target:IsValid() ) then
			
			local pos = self.Target:GetPos();
			self:DoCommonBecomeAlertSound();
			self.Alerted = true;
		
		else
			
			if( self.CanIdleWalk and CurTime() > self.NextRandomPathWander ) then
			
				local d = math.random( 1, 30 );
				
				if( d > 5 ) then
					
					self:StartSchedule( SCHED.WanderAimless );
					
				else
				
					self:StartSchedule( SCHED.RunAimless );
					self:DoCommonAlertSound();
				
				end
				
				self.NextRandomPathWander = CurTime() + math.random( 4, 10 );
				
			end
		
		end
	
	else
		
		if( not self:QualifiedTarget( self.Target ) ) then
		
			self.Target = nil;
			self.Alerted = false;
			self.CanIdleWalk = true;
			self.LastSeen = -30;
			
			return;
		
		else
		
			self:FindEnemy();
		
		end
		
		local tdist = ( self:GetPos() - self.Target:GetPos() ):Length();
		
		local vis = self:CanSee( self.Target );
		
		if( vis ) then
			
			self.LastSeen = CurTime();
			
		end
		
		if( CurTime() - self.LastSeen < self.SearchTime ) then
			
			self:RunToEnemy( self.Target );
			
			if( CurTime() - self.RageSoundTime > 1 ) then
				
				self:DoCommonRageSound();
				self.RageSoundTime = CurTime();
				
			end
			
		elseif( CurTime() - self.LastSeen > self.SearchTime and CurTime() - self.LastSeen < self.SearchTime + 2 ) then
			
			self.Target = nil;
			self.Alerted = false;
			self.CanIdleWalk = true;
			self.LastSeen = -30;
			
			return;
			
		end
		
		if( tdist < 70 ) then
			
			if( vis ) then
				
				if( !self.AnimationRunning ) then
				
					self:PlayAnimation( "attack0" .. math.random( 1, 3 ) );
					self.Target:EmitSound( "necropolis/infected/common/miss/claw_miss_" .. math.random( 1, 2 ) .. ".wav" );
					self:AttackTarget();
					
				end
				
			end
		
		end
		
		if( CurTime() > self.NextEntityBlockCheck ) then
		
			local trace = { }
			trace.start = self:GetPos() + Vector( 0, 0, 32 );
			trace.endpos = trace.start + self:GetForward() * 70;
			trace.filter = self;
			
			local tr = util.TraceLine( trace );

			if( tr.Entity:IsValid() ) then
			
				if( tr.Entity:GetClass() == "func_breakable_surf" ) then
				
					self:StopMoving();
					self:PlayAnimation( "attack0" .. math.random( 1, 3 ) );
				
					timer.Simple( .5, function()
						
						if( tr.Entity:IsValid() ) then
							
							tr.Entity:EmitSound( "physics/glass/glass_sheet_break2.wav" );
							tr.Entity:Remove();
							
						end
						
					end );
				
				elseif( tr.Entity:GetClass() == "prop_door_rotating" ) then -- replaced IsDoor as brush ents don't have physics objects or models to create!
					
					self:StopMoving();
					self:PlayAnimation( "attack0" .. math.random( 1, 3 ) );
					
					tr.Entity:EmitSound( "physics/wood/wood_crate_impact_hard2.wav" );
					tr.Entity:EmitSound( "physics/wood/wood_panel_impact_hard1.wav", 100, math.random( 70, 130 ) );
					
					HandleDoorDamage( tr.Entity, self );
					
				elseif( tr.Entity:GetClass() == "prop_physics" ) then
				
					self:StopMoving();
					self:PlayAnimation( "attack0" .. math.random( 1, 3 ) );
					
					self:EmitSound( ZombieHit[math.random( 1, #ZombieHit )] );
					
					local norm = ( tr.Entity:GetPos() - self:GetPos() ):Normalize();
				
					tr.Entity:GetPhysicsObject():ApplyForceOffset( norm * 6000, tr.HitPos );
					
				end
				
			end
			
			self.NextEntityBlockCheck = CurTime() + .7;
			
		end
		
	
	end

end

function ENT:Think()
	
	if( self.Dead ) then return end
	
	self:HandleSound();
	
	if( CurTime() > self.NextThinkTime ) then
	
		self:ZombieThink();
		self.NextThinkTime = CurTime() + .3;
	
	end 

end
	


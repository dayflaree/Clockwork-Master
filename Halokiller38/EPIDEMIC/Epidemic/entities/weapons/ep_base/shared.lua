if ( SERVER ) then 
	
	AddCSLuaFile( "shared.lua" ) 
	
end 

SWEP.HoldType 				= "pistol";

SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= false 

SWEP.Primary.HolsteredAtStart = true;

SWEP.HealthAmt 						= 100;
SWEP.Degrades 						= true;
SWEP.DegradeAmt 					= 0; --Degrade amount is the amount it degrades health by every 15 bullets.
SWEP.NextDegSave 					= 0;
SWEP.BulletsShotSinceLastDegrade 	= 0;

--Jams only occur when gun health is at <30%
SWEP.Jams 							= true;
SWEP.JamChance 						= 0; --Jam chance is any number from 0-100.  The higher the number, the higher the chance it jams.
SWEP.BulletsShotBeforeJam 			= 0; --Amount of bullets to shoot before it randomly decides if the gun should jam.
SWEP.BulletsShotSinceLastJamChance 	= 0;

SWEP.Primary.CanToggleHolster 		= true;

SWEP.Primary.PositionPosOffset 		= Vector( 0, 0, 0 );
SWEP.Primary.PositionAngleOffset 	= Angle( 0, 0, 0 );
SWEP.Primary.PositionOffsetSet 		= false;

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" ) 
SWEP.Primary.Damage			= 40 
SWEP.Primary.Force			= 10
SWEP.Primary.NumShots		= 1 
SWEP.Primary.Cone			= 0.02 
SWEP.Primary.Delay			= 0.15 
SWEP.Primary.Tracer 		= "Tracer";
SWEP.Primary.ReloadDelay 	= 1.5;
SWEP.Primary.ReloadTimer 	= 0;

SWEP.Primary.LastShot 		= 0;
SWEP.Primary.NextEmptyClick = 0;

SWEP.Primary.Recoil			= .2 
SWEP.Primary.RecoilAdd		= .1
SWEP.Primary.RecoilMin 		= .2
SWEP.Primary.RecoilMax 		= .6
SWEP.Primary.RecoverTime 	= 1;

SWEP.Primary.PositionMode 			= 2;
SWEP.Primary.PositionTime 			= .2;
SWEP.Primary.PositionMul 			= 1;
SWEP.Primary.GoToOriginalPosition 	= false;
SWEP.Primary.NextPositionMode 		= 0;
SWEP.Primary.OldPositionMode 		= 0;

SWEP.MuzzleDepth = 10;

SWEP.Primary.SpreadCone 		= Vector( .05, .05, .05 );

SWEP.Primary.ReloadingAmount 	= 0;
SWEP.Primary.CurrentAmmo 		= 0;
SWEP.Primary.CurrentClip 		= 0;
SWEP.Primary.Automatic			= false 
SWEP.Primary.Ammo				= "none" 

SWEP.Primary.ViewPunchMul = 1;

SWEP.NextPrimaryAttack = 0;

SWEP.Slot = 2;

SWEP.Melee 				= false;
SWEP.Charging 			= false;
SWEP.ChargeTimeStart 	= 0;
SWEP.ChargeTimeMax 		= 0;

SWEP.HitWorldVol_Low = 100;
SWEP.HitWorldVol_High = 100;

SWEP.HitBodVol_Low = 100;
SWEP.HitBodVol_High = 100;

SWEP.BreaksDoors = false;

SWEP.FireMode = 1;


function SWEP:Initialize() 
	
 	self:SetWeaponHoldType( self.HoldType );
 	
	if( self.NoHolster ) then
	
		self.Primary.CanToggleHolster = false;
		self.Primary.HolsteredAtStart = false;
		
	else	
		
		self.Primary.CanToggleHolster = true;
		self.Primary.HolsteredAtStart = true;
		
	end
	
	if( SERVER ) then
		
		timer.Simple( .4, function()
			
			umsg.Start( "msgSetDegradeAmt", self.Owner );
				umsg.Short( self.HealthAmt );
				umsg.Entity( self );
			umsg.End();
			
		end );
		
	end
	
end

if( CLIENT ) then
	
	function msgSetDegradeAmt( um )
		
		local num = um:ReadShort();
		local ent = um:ReadEntity();
		if( ent and ent:IsValid() ) then
			
			ent.HealthAmt = num;
			
		end
		
	end
	usermessage.Hook( "msgSetDegradeAmt", msgSetDegradeAmt );

end
 
function SWEP:GetWeaponHoldType()
	
	return self.EpiHoldType;
	
end
   
function SWEP:Deploy( unholster )
	
	if( !unholster ) then
		
		if( SERVER and self.Degrades ) then
			
			if( self.HeavyWeight ) then
				
				self.Owner:sqlUpdateField( "HWDeg", self.HealthAmt, true );
				
			else
				
				self.Owner:sqlUpdateField( "LWDeg", self.HealthAmt, true );
				
			end
			
		end
		
	else
		
		self:SendWeaponAnim( ACT_VM_DRAW );
		if( SERVER ) then
			self:OnDrawSound();
		end
		
	end
	
	if( self.L4D and CLIENT ) then
		
		self.Arms = ClientsideModel( "models/weapons/necropolis/v_models/v_l4d2arms.mdl" );
		
	end
	
end
 
function SWEP:GetMeleePowerPerc()
	
	local t1 = CurTime() - self.ChargeTimeStart;
	local t2 = self.ChargeTimeMax - self.ChargeTimeStart;
	return math.Clamp( t1 / t2, 0, 1 );
	
end
 
function SWEP:MeleeStrike( perc )
	
	if( self.Broken ) then return end
	
	local powerperc = perc;
	
	if( not perc ) then
		powerperc = 1 + self:GetMeleePowerPerc();
	end
	
	self.Weapon:SendWeaponAnim( table.Random( self.Anims ) );
	
	self.NextPrimaryAttack = CurTime() + self:SequenceDuration();
	
	self.Owner:ViewPunch( Angle( 10, 10, 0 ) );
	
	if( SERVER ) then
		
		self.Owner:EmitSound( Sound( table.Random( self.SwingSounds ) ), 60, 100 );
		
	end
	
	if( self.Owner:GetTable().AnimTable and self.Owner:GetTable().AnimTable == 19 ) then
		self.Owner:DoAnimationEvent( ACT_MELEE_ATTACK_SWING_GESTURE );
	else
		self.Owner:DoAnimationEvent( ACT_MELEE_ATTACK_SWING );
	end
	
	self.ChargeTimeStart = CurTime();
	self.ChargeTimeMax = CurTime() + 1;
	
	local trace 	= { };
	trace.start 	= self.Owner:EyePos();
	trace.endpos	= trace.start + self.Owner:GetAimVector() * 40;
	trace.filter 	= self.Owner;
	
	local tr 		= util.TraceLine( trace );
	
	local tbl 		= ents.FindInSphere( tr.HitPos, 10 );
	
	if( #tbl > 0 ) then
		
		self.BulletsShotSinceLastDegrade = self.BulletsShotSinceLastDegrade + 1;
		
		if( self.BulletsShotSinceLastDegrade >= 3 ) then
			
			self.BulletsShotSinceLastDegrade = 0;
			
			self.HealthAmt = math.Clamp( self.HealthAmt - self.DegradeAmt, 0, 100 );
			
			if( SERVER ) then
				
				if( self.HeavyWeight ) then
					
					self.Owner:sqlUpdateField( "HWDeg", self.HealthAmt, true );
					
				else
					
					self.Owner:sqlUpdateField( "LWDeg", self.HealthAmt, true );
					
				end
				
			end
			
		end
		
	end
	
	if( SERVER ) then
		
		for k, v in pairs( tbl ) do
			
			if( v ~= self.Owner and not string.find( v:GetClass(), "func_" ) ) then
				
				local norm = ( self.Owner:GetPos() - v:GetPos() ):Normalize();
				
				local dmgpos = v:GetPos();
				dmgpos.z = tr.HitPos.z;
				
				if( SERVER ) then
					
					if( v:GetClass() == "ep_commonzombie" or v:IsPlayer() or v:IsNPC() ) then
						
						v:EmitSound( Sound( table.Random( self.HitBodSounds ) ), math.random( self.HitBodVol_Low, self.HitBodVol_High ) * .45, 100 );
						
					else
						
						self.Owner:EmitSound( Sound( table.Random( self.HitWorldSounds ) ), math.random( self.HitWorldVol_Low, self.HitWorldVol_High ) * .45, 100 );
						
					end
					
				end
				
				HandleMeleeDamage( v, self.Primary.Damage * .6, self.Primary.Damage, dmgpos, self.Owner );
				
				if( not v:IsPlayer() and v:GetPhysicsObject():IsValid() ) then
					v:GetPhysicsObject():ApplyForceOffset( norm * -9000 * math.Clamp( powerperc, .4, 1 ), tr.HitPos );
				else
					local push = -80 * norm * powerperc;
					v:SetVelocity( push );
				end
				
			elseif( v:GetClass() == "func_breakable" or v:GetClass() == "func_breakable_surf" ) then
				
				v:Fire( "Break", "", 0 );
				
			end
			
		end
		
	end
	
end
   
function SWEP:Think() 
	
	if( self:GetNWBool( "reloading", false ) and self.ShotgunReload ) then 
		
 		if( self.Primary.ReloadTimer < CurTime() ) then
 			
 			if( self.Primary.ReloadingAmount <= -1 ) then
				
 				self:SetNWBool( "reloading", false );
 				return;
				
 			end
			
			self:SendWeaponAnim( ACT_VM_RELOAD );
			if( SERVER ) then
				self:OnReloadSound();
			end
			
			self.Primary.ReloadTimer = CurTime() + self:SequenceDuration();
			self.Primary.ReloadingAmount = self.Primary.ReloadingAmount - 1;
			
			if( self.Primary.ReloadingAmount <= -1 ) then
				
				self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
				
				if( SERVER ) then
					self:OnReloadEndSound();
				end
				
				if( self.ReloadCB ) then
					
					self.ReloadCB();
					
				end
				
			end
			
 		end 
		
 	end
	
	if( CLIENT and self.L4D and self.Arms ) then
		
		self:ValidateArms();
		
	end
	
end

function SWEP:BreakDoor( door )
	
	if( SERVER ) then
		
		door:EmitSound( "physics/wood/wood_panel_impact_hard1.wav", 100, math.random( 70, 130 ) );
		
		local pos = door:GetPos();
		local ang = door:GetAngles();
		local mdl = door:GetModel();
		local skin = door:GetSkin();
		
		door:SetNoDraw( true );
		
		door:Remove();
		
		local fake = ents.Create( "prop_physics" );
		
		fake:SetPos( pos );
		fake:SetAngles( ang );
		fake:SetModel( mdl );
		fake:SetSkin( skin );

		fake:Spawn();
		
		local off = ( self:GetPos() - fake:GetPos() ):Normalize();
		fake:SetVelocity( Vector( off.x * -80000, off.y * -80000, 0 ) );
		
	end
	
end

function SWEP:OnReload() 
	
 	if( self:GetNWBool( "reloading", false ) ) then return end
	
	if( self.Primary.CurrentClip == self.Primary.MaxAmmoClip ) then
		
		return;
		
	end
	
	self:SetNWBool( "reloading", true );
	
 	if( self.ShotgunReload ) then
		
		if( self.Primary.CurrentClip < self.Primary.MaxAmmoClip and self.Primary.ReloadingAmount > 0 ) then
			
			self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START );
			if( SERVER ) then
				self:OnReloadStartSound();
			end
			self.Primary.ReloadTimer = CurTime() + self:SequenceDuration();
			
		end
		
 	else
		
		local function reload()
			
			if( self.ReloadCB ) then
				
				self.ReloadCB();
				
			end
			
			self:SetNetworkedBool( "reloading", false );
			
		end
		timer.Simple( self.Primary.ReloadDelay, reload );
		
		self:SendWeaponAnim( ACT_VM_RELOAD );
		if( SERVER ) then
			self:OnReloadSound();
		end
		
		timer.Simple( self:SequenceDuration(), function()
			
			if( self and self:IsValid() ) then
				
				self:SendWeaponAnim( ACT_VM_IDLE );
				
			end
			
		end );
		
		if( self.Owner:GetTable().AnimTable and AnimTables[self.Owner:GetTable().AnimTable].Reload ) then
			
			self.Owner:DoAnimationEvent( AnimTables[self.Owner:GetTable().AnimTable].Reload[self.EpiHoldType] );
			
		end
		
	end
	
end

function SWEP:OnUnload() 
	
 	if( self:GetNWBool( "reloading", false ) ) then return end
 	if( self:GetNWBool( "unloading", false ) ) then return end
	
	if( self.Primary.CurrentClip == 0 ) then
		
		return;
		
	end
	
	self:SetNWBool( "unloading", true );
	
	local function unload()
		
		if( self.UnloadCB ) then
			
			self.UnloadCB();
			
		end
		
		self:SetNetworkedBool( "unloading", false );
		
	end
	timer.Simple( self.Primary.ReloadDelay, unload );
	
	self:SendWeaponAnim( ACT_VM_RELOAD );
	if( SERVER ) then
		self:OnReloadSound();
	end
	
	timer.Simple( self:SequenceDuration(), function()
		
		if( self and self:IsValid() ) then
			
			self:SendWeaponAnim( ACT_VM_IDLE );
			
		end
		
	end );
	
	if( self.Owner:GetTable().AnimTable and AnimTables[self.Owner:GetTable().AnimTable].Reload ) then
		
		self.Owner:DoAnimationEvent( AnimTables[self.Owner:GetTable().AnimTable].Reload[self.EpiHoldType] );
		
	end
	
end

function SWEP:OnReloadStartSound()
end

function SWEP:OnReloadSound()
end

function SWEP:OnReloadEndSound()
end

function SWEP:OnPrimarySound()
end

function SWEP:OnDrawSound()
end

function SWEP:Reload() 
end 

 
function SWEP:SecondaryAttack()
end


function SWEP:DestroyWep()
	
	if( SERVER ) then
		
		if( self.HeavyWeight ) then
		
			self.Owner:sqlUpdateField( "HeavyWeaponry", "", true );
		
		else
		
			self.Owner:sqlUpdateField( "LightWeaponry", "", true );
		
		end
		
		if( self.HeavyWeight ) then
			self.Owner:RemoveHeavyWeapon();
		else
			self.Owner:RemoveLightWeapon();
		end
		
		self:EmitSound( Sound( "physics/wood/wood_box_break2.wav" ) );
		
		self:Remove();
		
	end
	
end


function SWEP:PrimaryAttack() 
	
	self.Primary.PositionChange = CurTime();
	
	if( self:GetNetworkedBool( "reloading", false ) ) then return end

	if( CurTime() < self.NextPrimaryAttack ) then
		
		return;
		
	end
	
	if( self.Owner:GetNWBool( "Holstered", true ) ) then
		
		return;
		
	end
	
	self.NextPrimaryAttack = CurTime() + self.Primary.Delay;
	
	if( self.OverridePrimary ) then
		
		return;
	
	end
	
	if( self.Melee ) then
		
		if( self.Broken ) then
			
			return;
			
		end
		
		if( self.HealthAmt <= 5 and !self.Broken ) then -- totally fucked
			
			self.Broken = true;
			self:DestroyWep();
			
		end
		
		local mul = 0;
		
		if( self.ChargeTimeStart > 0 ) then
			
			mul = nil;
			
		else
			
			mul = math.Rand( .8, 1.2 );
			
		end
		
		self:MeleeStrike( mul );
		return;
	
	end
	
	if( self.Primary.CurrentClip <= 0 ) then
		
		if( self.Primary.NextEmptyClick < CurTime() ) then
			
			self.Weapon:EmitSound( Sound( "Weapon_Pistol.Empty" ) );
			self.Primary.NextEmptyClick = CurTime() + .4;
			
		end
		
		return;
		
	end
   	
	local vel = self.Owner:GetVelocity():Length2D();
	
	if( vel > 120 ) then
		
		if( self.Owner:KeyDown( IN_WALK ) ) then
			
			return;
			
		end
		
	end
	
	if( self.Jams and self.HealthAmt and self.HealthAmt <= 5 and !self.Jammed ) then -- totally fucked
		
		self.Jammed = true;
		self.Broken = true;
		self:EmitSound( Sound( "weapons/shotgun/shotgun_empty.wav" ) );
		
	end
	
	if( self.Jams and self.HealthAmt and self.HealthAmt <= 70 and not self.Jammed ) then
		
		if( self.BulletsShotSinceLastJamChance >= self.BulletsShotBeforeJam ) then
			
			self.BulletsShotBeforeJam = math.Clamp( 1, 5 );
			self.BulletsShotSinceLastJamChance = 0;
			
			local amt = self.HealthAmt - 30;
			if( amt <= 0 ) then amt = 1; end
			
			if( math.random( 1, 100 * amt ) <= self.JamChance ) then
				
				self.Jammed = true;
				self.UnJamming = false;
				self:EmitSound( Sound( "weapons/shotgun/shotgun_empty.wav" ) );
				
				self:SendWeaponAnim( ACT_VM_RELOAD );
				if( SERVER ) then
					self:OnReloadSound();
				end
				
				timer.Simple( self.Primary.ReloadDelay, function()
					
					self.Jammed = false;
					
				end );
				
			end
			
		end
		
	end
	
   	if( not self.Jammed ) then
		
		local recov = math.Clamp( ( CurTime() - self.Primary.LastShot ) / self.Primary.RecoverTime, 0, 1 );
		recov = 1 - recov;
		
		self.Primary.Recoil = math.Clamp( self.Primary.Recoil * recov, self.Primary.RecoilMin, self.Primary.RecoilMax );
		
		self:ShootBullets();
		
	end
	
end


function SWEP:ShootBullets()
	
	local mul = 1;
	
	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 110 ) then
		mul = 5;
	elseif( self.Owner:GetVelocity():Length() > 40 ) then
		mul = 2;
	end
	
	if( self.Owner:KeyDown( IN_ATTACK2 ) ) then
		
		mul = mul * .7;
		
	end
	
	local recoiladd = 0;
	local rdmg, ldmg;
	
	if( SERVER ) then
		
		self.Owner:GetTable().LastShot = CurTime();
		
		rdmg = math.Clamp( 60 - self.Owner:GetPlayerRArmHP(), 0, 60 );
		ldmg = math.Clamp( 60 - self.Owner:GetPlayerLArmHP(), 0, 60 );
		
	else
		
		rdmg = math.Clamp( 60 - ClientVars["RArmHP"], 0, 60 );
		ldmg = math.Clamp( 60 - ClientVars["LArmHP"], 0, 60 );
		
	end
	
	local dmg = rdmg + ldmg;
	
	recoiladd = 2 * ( dmg / 40 );
	
	local aimvec = self.Owner:GetAimVector();
	
	local bullet 		= {};
	bullet.Num 			= self.Primary.NumShots;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= aimvec;
	bullet.Spread 		= ( self.Primary.SpreadCone + Vector( .04, .04, .04 ) * ( self.Primary.Recoil + recoiladd ) ) * mul;
	bullet.Tracer		= 1;
	bullet.Force		= self.Primary.Force;
	bullet.Damage		= self.Primary.Damage;
	bullet.TracerName 	= self.Primary.Tracer;
	
	bullet.Callback = function( attacker, tr, dmginfo )
		
		--[[if( self.BreaksDoors ) then
			
			if( tr.Entity and tr.Entity:IsValid() ) then
				
				if( tr.Entity:GetClass() == "prop_door_rotating" ) then
					
					self:BreakDoor( tr.Entity );
					
				end
				
			end
			
		end--]]
		
		local pos = tr.HitPos + aimvec * 20;
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() and util.PointContents( pos ) != CONTENTS_SOLID ) then
			
			local bulletp 		= {};
			bulletp.Num 		= self.Primary.NumShots;
			bulletp.Src 		= pos;
			bulletp.Dir 		= aimvec;
			bulletp.Spread 		= ( self.Primary.SpreadCone + Vector( .04, .04, .04 ) * ( self.Primary.Recoil + recoiladd ) ) * mul;
			bulletp.Tracer		= 1;
			bulletp.Force		= self.Primary.Force;
			bulletp.Damage		= self.Primary.Damage;
			bulletp.TracerName 	= self.Primary.Tracer;
			
			self.Owner:FireBullets( bulletp );
			
		end
		
	end
	
	self.Primary.CurrentAmmo = self.Primary.CurrentAmmo - 1;
	self.Primary.CurrentClip = self.Primary.CurrentClip - 1;
	
	if( SERVER ) then
		
		if( self.HeavyWeight ) then
			
			self.Owner:SetPlayerHWAmmo( self.Primary.CurrentClip );
			
		else
			
			self.Owner:SetPlayerLWAmmo( self.Primary.CurrentClip );
			
		end
		
	end
	
	self.Owner:FireBullets( bullet );
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	
	local ownhand = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" );
	
	if( CLIENT and EyePos():Distance( LocalPlayer():EyePos() ) < 5 ) then
		
		ownhand = self.Owner:LookupBone( "ValveBiped.Bip01_Head1" );
		
	end
	
	if( self.Owner:GetTable().AnimTable and AnimTables[self.Owner:GetTable().AnimTable].Shoot ) then
		
		self.Owner:DoAnimationEvent( AnimTables[self.Owner:GetTable().AnimTable].Shoot );
		
	end
	
	if( SERVER ) then
		
		if( self.Primary.SoundTab ) then
			
			self.Owner:EmitSound( table.Random( self.Primary.SoundTab ), 350 );
			
		else
			
			self.Owner:EmitSound( self.Primary.Sound, 350 );
			
		end
		
		self:OnPrimarySound( self:GetSequence() );
		
	end
	
	self.Primary.Recoil = math.Clamp( self.Primary.Recoil + self.Primary.RecoilAdd, self.Primary.RecoilMin, self.Primary.RecoilMax );
	
	self:ApplyRecoil( recoiladd );
	
	if( self.Degrades ) then
		
		self.BulletsShotSinceLastDegrade = self.BulletsShotSinceLastDegrade + 1;
		
		if( self.BulletsShotSinceLastDegrade >= 15 ) then
			
			self.BulletsShotSinceLastDegrade = 0;
			
			self.HealthAmt = math.Clamp( self.HealthAmt - self.DegradeAmt, 0, 100 );
			
			if( SERVER ) then
				
				if( self.HeavyWeight ) then
					
					self.Owner:sqlUpdateField( "HWDeg", self.HealthAmt, true );
					
				else
					
					self.Owner:sqlUpdateField( "LWDeg", self.HealthAmt, true );
					
				end
				
			end
			
		end
		
	end
	
	if( self.Jams ) then
		
		self.BulletsShotSinceLastJamChance = self.BulletsShotSinceLastJamChance + 1;
		
   	end
	
end

function SWEP:ChangeFireMode( mode )
	
	self.FireMode = mode;
	
	if( self.OnChangeFireMode ) then
		
		self:OnChangeFireMode();
		
	end
	
end

function SWEP:ApplyRecoil( add )
	
	local eyeang = Angle(
		( self.Primary.Recoil + add ) * math.Rand( -1, -0.5 ),
 		( self.Primary.Recoil + add ) * math.Rand( -.1, .1 ),
		0 );
		
	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 110 ) then
		eyeang = eyeang * 4;
	elseif( self.Owner:GetVelocity():Length() > 40 ) then
		eyeang = eyeang * 2;
	end
	
	self.Owner:ViewPunch( eyeang * self.Primary.ViewPunchMul );
	
	if( SERVER and not self.Owner:IsListenServerHost() ) then return; end
	
	if( self.Owner:InVehicle() ) then return; end
	
	self.Owner:SetEyeAngles( eyeang + self.Owner:EyeAngles() );
	
end


function SWEP:GoIntoPosition( pos, ang, newpos, newang, overridemul )
	
	local mul = overridemul or self.Primary.PositionMul;
	
	if( newang ) then
		
		ang:RotateAroundAxis( ang:Right(), 		mul * newang.p );
		ang:RotateAroundAxis( ang:Up(), 		mul * newang.y );
		ang:RotateAroundAxis( ang:Forward(), 	mul * newang.r );
		
	end
	
	pos = pos + newpos.x * ang:Right() * mul;
	pos = pos + newpos.y * ang:Up() * mul;
	pos = pos + newpos.z * ang:Forward() * mul;
	
	return pos, ang;
	
end


function SWEP:GetViewModelPosition( pos, ang ) 
	
	if( self.Primary.OverrideDefaultPos ) then
		
		pos, ang = self:GoIntoPosition( pos * 1, ang * 1, self.Primary.OverrideDefaultPos, self.Primary.OverrideDefaultAng or Angle( 0, 0, 0 ), 1 );
		
	end
	
	if( IRONSIGHTS_DEV ) then
		
		self.Primary.PositionMul = 1;
		self.Primary.PositionMode = 1;
		
	end
	
	if( self.Primary.OldPositionMode == 0 or self.Primary.PositionMul == 1 ) then
		
		self.Primary.OldPositionMode = self.Primary.PositionMode;
		
	end
	
	if( self.Primary.PositionMode == 1 ) then --Going into iron sights
		if( self.Primary.IronSightPos ) then
			pos, ang = self:GoIntoPosition( pos * 1, ang * 1, self.Primary.IronSightPos + self.Primary.PositionPosOffset, ( self.Primary.IronSightAng or Angle( 0, 0, 0 ) ) + self.Primary.PositionAngleOffset );
		end
	elseif( self.Primary.PositionMode == 2 ) then --Going holstered/unholstered
		if( self.Primary.HolsteredPos ) then
			pos, ang = self:GoIntoPosition( pos * 1, ang * 1, self.Primary.HolsteredPos, self.Primary.HolsteredAng or Angle( 0, 0, 0 ) );
		end
	elseif( self.Primary.PositionMode == 3 ) then --Charge
		if( self.Primary.ChargedPos ) then
			pos, ang = self:GoIntoPosition( pos * 1, ang * 1, self.Primary.ChargedPos, self.Primary.ChargedAng or Angle( 0, 0, 0 ) );
		end 	 
	end
	
	if( self.Primary.GoToOriginalPosition ) then
		
		self.Primary.PositionMul = math.Clamp( self.Primary.PositionMul - ( 1 / self.Primary.PositionTime ) * FrameTime(), 0, 1 );	
		
		if( self.Primary.PositionMul == 0 ) then
			
			self.Primary.PositionMode = self.Primary.NextPositionMode;
			self.Primary.GoToOriginalPosition = false;
			
	 	end
		
	else
		
		self.Primary.PositionMul = math.Clamp( self.Primary.PositionMul + ( 1 /self.Primary.PositionTime ) * FrameTime(), 0, 1 );			 
		
	end
	
	return pos, ang;
	
end


function SWEP:ValidateArms()
	
	self.Arms:SetPos( self.Owner:GetViewModel():GetPos() );
	self.Arms:SetAngles( self.Owner:GetViewModel():GetAngles() );
	self.Arms:AddEffects( EF_BONEMERGE );
	self.Arms:SetNoDraw( true );
	self.Arms:SetParent( self.Owner:GetViewModel() );
	
end

function SWEP:ViewModelDrawn()
	
	if( self.L4D ) then
		
		if( self.Arms ) then
			
			self:ValidateArms();
			self.Arms:DrawModel();
			
		end
		
	end
	
end

function SWEP:Holster()
	
	self.Arms = nil;
	return true;
	
end

if( CLIENT ) then
	
	function SWEP:HolsterToggle()
		
		if( self.Scoped ) then
			
			ScopeMode( false );
			
		end
		
	end
	
	SWEP.Zoom = 30;
	
	SeeSniperScope = false;
	local upperleft = surface.GetTextureID( "scope/scope_sniper_ul" );
	local upperright = surface.GetTextureID( "scope/scope_sniper_ur" );
	local lowerleft = surface.GetTextureID( "scope/scope_sniper_ll" );
	local lowerright = surface.GetTextureID( "scope/scope_sniper_lr" );
	
	function SWEP:DrawHUD()
		
		if( IRONSIGHTS_DEV ) then
			
			local trace = { }
			
			trace.start = LocalPlayer():GetShootPos();
			trace.endpos = trace.start + LocalPlayer():GetAimVector() * 4096;
			trace.filter = LocalPlayer();
			
			local tr = util.TraceLine( trace );
			
			local effectd = EffectData();
			effectd:SetStart( LocalPlayer():GetShootPos() - Vector( 0, 10, 0 ) );
			effectd:SetOrigin( tr.HitPos );
			util.Effect( "ToolTracer", effectd );
			
		end
		
		if( self.Scoped ) then
			
			if( math.floor( self.Primary.PositionMode ) == 1 and math.floor( self.Primary.PositionMul ) == 1 ) then 
				
				if( not ScopeOn ) then
					
					ScopeMode( true );
					
				end
				
				local wh = ScrW();
				local hh = ScrH();
				
				local h1 = hh / 2;
				local w1 = h1 * (4/3);
				
				local left = ( wh - ( w1 * 2 ) ) / 2;
				
				surface.SetDrawColor( 255, 255, 255, 255 );
				
				surface.SetTexture( upperleft );
				surface.DrawTexturedRect( left, 0, w1, h1 );
				surface.SetTexture( upperright );
				surface.DrawTexturedRect( left + w1, 0, w1, h1 );
				surface.SetTexture( lowerleft );
				surface.DrawTexturedRect( left, h1, w1, h1 );
				surface.SetTexture( lowerright );
				surface.DrawTexturedRect( left + w1, h1, w1, h1 );
				
				surface.SetDrawColor( 0, 0, 0, 255 );
				surface.DrawRect( 0, 0, left, h1 * 2 );
				surface.DrawRect( left + ( w1 * 2 ), 0, left, h1 * 2 );
				
				local tr = LocalPlayer():GetEyeTrace();
				
				if( tr.Entity and tr.Entity:IsValid() ) then
					
					if( tr.Entity:IsPlayer() ) then
						
						local pos = tr.Entity:EyePos() + Vector( 0, 0, 10 );
						pos = pos:ToScreen();
						
						local x = pos.x;
						local y = pos.y;
						
						if( tr.Entity:GetTable().Title ) then
							
							draw.DrawText( tr.Entity:GetTable().Title, "CharCreateEntry", x, y, Color( 255, 255, 255, 255 ), 1 );
							
						else
							
							RunConsoleCommand( "eng_recply", tr.Entity:EntIndex() );
							tr.Entity:GetTable().ChangedTitleInfo = false;
							
						end
						
					elseif( tr.Entity:GetClass() == "ep_commonzombie" ) then
						
						local pos = tr.Entity:EyePos() + Vector( 0, 0, 10 );
						pos = pos:ToScreen();
						
						local x = pos.x;
						local y = pos.y;
						
						draw.DrawText( "Infected", "CharCreateEntry", x, y, Color( 255, 255, 255, 255 ), 1 );
						
					end
					
				end
				
			elseif( ScopeOn ) then
				
				ScopeMode( false );
				
			end
			
		end
		
	end
	
end

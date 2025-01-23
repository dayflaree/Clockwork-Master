 
 --TS2 swep base modded for Gear
 
 if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 

 end 

   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 

SWEP.Primary.PositionPosOffset = Vector( 0, 0, 0 );
SWEP.Primary.PositionAngleOffset = Angle( 0, 0, 0 );
SWEP.Primary.PositionOffsetSet = false;

 SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" ) 
 SWEP.Primary.Damage			= 40 
 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.Cone			= 0.02 
 SWEP.Primary.Delay			= 0.15 
 SWEP.Primary.Tracer = "Tracer";
 SWEP.Primary.ReloadDelay = 1.5;
 
 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .6
 SWEP.Primary.RecoverTime = 1;
 
 SWEP.Primary.SpreadCone = Vector( .05, .05, .05 );
   
 SWEP.Primary.ClipSize		= -1 
 SWEP.Primary.DefaultClip	= -1 
 SWEP.Primary.Automatic		= false 
 SWEP.Primary.Ammo			= "none" 

 SWEP.Primary.ViewPunchMul = 1;

 SWEP.Slot = 2;
   
 /*--------------------------------------------------------- 
 ---------------------------------------------------------*/ 
 function SWEP:Initialize() 
   
 	if ( SERVER ) then 
 		self:SetWeaponHoldType( self.HoldType );
 	end
 	
 	
 	 
 end 
 
 function SWEP:GetWeaponHoldType()
 
 	return self.TS2HoldType;
 
 end
   
 function SWEP:Deploy()
 
 	--self.Owner:CrosshairDisable(); 
 
 end
   
 function SWEP:Think() 
   
 	if ( self.Weapon:GetNetworkedBool( "reloading", false ) and self.ShotgunReload ) then 
 	 
 		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then 
 			 
 			// Finsished reload - 
 			if ( self.Primary.ClipSize >= self.Primary.DefaultClip ) then 
 				self.Weapon:SetNetworkedBool( "reloading", false ) 
 				return 
 			end 
 			 
 			// Next cycle 
 			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 ) 
 			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD ) 
 			 
 			self.Primary.ClipSize = self.Primary.ClipSize + 1;
 			 
 			// Finish filling, final pump 
 			if ( self.Primary.ClipSize >= self.Primary.DefaultClip ) then 
 				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH ) 
 			else 
 			 
 			end 
 			 
 		end 
 	 
 	end 
   
 end  
 
 function SWEP:Reload() 

 	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	 
	 if( self.Primary.ClipSize == self.Primary.DefaultClip ) then
	 
	 	return;
	 
	 end
	 
	self.Weapon:SetNetworkedBool( "reloading", true )
	 
 	if( self.ShotgunReload ) then
		
		if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
			
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
		end
 	
 	else
 	
	 	local function reload()
	 
		 	if( self.Primary.ClipSize < self.Primary.DefaultClip ) then
		 	
		 		local diff = self.Primary.DefaultClip - self.Primary.ClipSize;
		 		self.Primary.ClipSize = self.Primary.DefaultClip;
		 		self.Weapon:SetNetworkedBool( "reloading", false );
		 	
		 	end
		 	
		end
		timer.Simple( self.Primary.ReloadDelay, reload );
	 	
 		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )

	end

 end 

 
 function SWEP:SecondaryAttack() 

	
 end 
 
  SWEP.Primary.LastShot = 0;
  
  SWEP.Primary.NextEmptyClick = 0;
   
 function SWEP:PrimaryAttack() 
   
   self.Primary.PositionChange = CurTime();
   
   if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
   
	if( self.Primary.ClipSize <= 0 ) then
		if( self.Primary.NextEmptyClick < CurTime() ) then
			self.Weapon:EmitSound( Sound( "Weapon_Pistol.Empty" ) );
			self:Reload();
			self.Primary.NextEmptyClick = CurTime() + .4;
		end
		return; 
	end

   	if( CurTime() - self.Primary.LastShot < self.Primary.Delay ) then
   	
   		return;
   	
   	end

   	local recov = math.Clamp( ( CurTime() - self.Primary.LastShot ) / self.Primary.RecoverTime, 0, 1 );
    recov = 1 - recov;
    
   	self.Primary.Recoil = math.Clamp( self.Primary.Recoil * recov, self.Primary.RecoilMin, self.Primary.RecoilMax );
   
 	self:ShootBullets();
 	 
 	self.Primary.LastShot = CurTime();
 	 
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
	
	 local bullet = {} 
 	bullet.Num 		= self.Primary.NumShots;
 	bullet.Src 		= self.Owner:GetShootPos()			// Source 
 	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet 
 	bullet.Spread 	= ( self.Primary.SpreadCone + Vector( .04, .04, .04 ) * self.Primary.Recoil ) * mul;
 	bullet.Tracer	= 1									// Show a tracer on every x bullets  
 	bullet.Force	= .1									// Amount of force to give to phys objects 
 	bullet.Damage	= self.Primary.Damage;
 	bullet.TracerName = self.Primary.Tracer;
	 
	self.Primary.ClipSize = self.Primary.ClipSize - 1;
 	 
 	self.Owner:FireBullets( bullet ) 
 	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation 
 	self.Owner:MuzzleFlash()								// Crappy muzzle light 
 	self.Owner:SetAnimation( PLAYER_ATTACK1 )
 	
 	self.Weapon:EmitSound( self.Primary.Sound );
 	
 	self.Primary.Recoil = math.Clamp( self.Primary.Recoil + self.Primary.RecoilAdd, self.Primary.RecoilMin, self.Primary.RecoilMax );
 	
	self:ApplyRecoil();
 	

end

function SWEP:ApplyRecoil()

 	local eyeang = Angle( self.Primary.Recoil * math.Rand( -1, .3 ),
 						  self.Primary.Recoil * math.Rand( -.7, .7 ), 0 );
 
 	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 110 ) then
 		eyeang = eyeang * 4;
 	 elseif( self.Owner:GetVelocity():Length() > 40 ) then
		eyeang = eyeang * 2;
	end
	
	self.Owner:ViewPunch( eyeang * self.Primary.ViewPunchMul );
 
	if( SERVER and not self.Owner:IsListenServerHost() ) then return; end
 
 	self.Owner:SetEyeAngles( eyeang + self.Owner:EyeAngles() ); 
 	 
 	

end

SWEP.Primary.PositionMode = 3;
SWEP.Primary.PositionTime = .2;
SWEP.Primary.PositionMul = 0;

function SWEP:GoIntoPosition( pos, ang, newpos, newang )

	local mul = self.Primary.PositionMul;

	if( newang ) then
	
		ang:RotateAroundAxis( ang:Right(), mul * newang.x );
		ang:RotateAroundAxis( ang:Up(), mul * newang.y );
		ang:RotateAroundAxis( ang:Forward(), mul * newang.z );
	
	end
	
	pos = pos + newpos.x * ang:Right() * mul;
	pos = pos + newpos.y * ang:Up() * mul;
	pos = pos + newpos.z * ang:Forward() * mul;

	return pos, ang;

end

 function SWEP:GetViewModelPosition( pos, ang ) 
	
	if( self.Primary.PositionMode == 1 ) then --Going into iron sights
		if( self.Primary.IronSightPos ) then
 			pos, ang = self:GoIntoPosition( pos * 1, ang * 1, self.Primary.IronSightPos + self.Primary.PositionPosOffset, ( self.Primary.IronSightAng or Vector( 0, 0, 0 ) ) + self.Primary.PositionAngleOffset );
 	 	end
 	end
 	 
 	 return pos, ang;
 	 
 end 
   


   

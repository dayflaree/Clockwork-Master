if( SERVER ) then 

	AddCSLuaFile( "shared.lua" )

end 

SWEP.HoldType = "pistol";
   
SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= false 
SWEP.Primary.HighPowered = true;
SWEP.Primary.DoorBreach = true;
SWEP.Primary.PenetrateDoors = true;
SWEP.Primary.CanCauseBleeding = true;

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
 
SWEP.TS2HoldType = "SHOTGUN";

SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;
SWEP.IconCamPos = Vector( 0, 0, 0 );
SWEP.IconLookAt = Vector( 0, 0, 0 );
SWEP.IconFOV = 90;

SWEP.ReloadSound = ""

SWEP.ScopeScale = 0.4

---------------------------------------------
---------------------------------------------

function SWEP:Initialize() 
	
	if( SERVER ) then
	
		self:SetWeaponHoldType( self.TS2HoldType );
		
	else	
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()
		
		self.Weapon.ScopeTable = { }
		self.Weapon.ScopeTable.l = iScreenHeight*self.Weapon.ScopeScale
		self.Weapon.ScopeTable.x1 = 0.5*(iScreenWidth + self.Weapon.ScopeTable.l)
		self.Weapon.ScopeTable.y1 = 0.5*(iScreenHeight - self.Weapon.ScopeTable.l)
		self.Weapon.ScopeTable.x2 = self.Weapon.ScopeTable.x1
		self.Weapon.ScopeTable.y2 = 0.5*(iScreenHeight + self.Weapon.ScopeTable.l)
		self.Weapon.ScopeTable.x3 = 0.5*(iScreenWidth - self.Weapon.ScopeTable.l)
		self.Weapon.ScopeTable.y3 = self.Weapon.ScopeTable.y2
		self.Weapon.ScopeTable.x4 = self.Weapon.ScopeTable.x3
		self.Weapon.ScopeTable.y4 = self.Weapon.ScopeTable.y1
		
		self.Weapon.ParaScopeTable = { }
		self.Weapon.ParaScopeTable.x = 0.5*iScreenWidth - self.Weapon.ScopeTable.l
		self.Weapon.ParaScopeTable.y = 0.5*iScreenHeight - self.Weapon.ScopeTable.l
		self.Weapon.ParaScopeTable.w = 2*self.Weapon.ScopeTable.l
		self.Weapon.ParaScopeTable.h = 2*self.Weapon.ScopeTable.l
		
		self.Weapon.ScopeTable.l = (iScreenHeight + 1)*self.Weapon.ScopeScale 

		self.Weapon.QuadTable = { }
		self.Weapon.QuadTable.x1 = 0
		self.Weapon.QuadTable.y1 = 0
		self.Weapon.QuadTable.w1 = iScreenWidth
		self.Weapon.QuadTable.h1 = 0.5*iScreenHeight - self.Weapon.ScopeTable.l
		self.Weapon.QuadTable.x2 = 0
		self.Weapon.QuadTable.y2 = 0.5*iScreenHeight + self.Weapon.ScopeTable.l
		self.Weapon.QuadTable.w2 = self.Weapon.QuadTable.w1
		self.Weapon.QuadTable.h2 = self.Weapon.QuadTable.h1
		self.Weapon.QuadTable.x3 = 0
		self.Weapon.QuadTable.y3 = 0
		self.Weapon.QuadTable.w3 = 0.5*iScreenWidth - self.Weapon.ScopeTable.l
		self.Weapon.QuadTable.h3 = iScreenHeight
		self.Weapon.QuadTable.x4 = 0.5*iScreenWidth + self.Weapon.ScopeTable.l
		self.Weapon.QuadTable.y4 = 0
		self.Weapon.QuadTable.w4 = self.Weapon.QuadTable.w3
		self.Weapon.QuadTable.h4 = self.Weapon.QuadTable.h3

		self.Weapon.LensTable = { }
		self.Weapon.LensTable.x = self.Weapon.QuadTable.w3
		self.Weapon.LensTable.y = self.Weapon.QuadTable.h1
		self.Weapon.LensTable.w = 2*self.Weapon.ScopeTable.l
		self.Weapon.LensTable.h = 2*self.Weapon.ScopeTable.l

		self.Weapon.CrossHairTable = { }
		self.Weapon.CrossHairTable.x11 = 0
		self.Weapon.CrossHairTable.y11 = 0.5*iScreenHeight
		self.Weapon.CrossHairTable.x12 = iScreenWidth
		self.Weapon.CrossHairTable.y12 = self.Weapon.CrossHairTable.y11
		self.Weapon.CrossHairTable.x21 = 0.5*iScreenWidth
		self.Weapon.CrossHairTable.y21 = 0
		self.Weapon.CrossHairTable.x22 = 0.5*iScreenWidth
		self.Weapon.CrossHairTable.y22 = iScreenHeight
		
	end
 	
end 
 
function SWEP:GetWeaponHoldType()
 
 	return self.TS2HoldType;
 
end
   
function SWEP:Deploy()
 
 	self.Owner:CrosshairDisable(); 
 
end

function SWEP:CanReload()

    if( SERVER and self.Owner:IsTied() ) then

		return false;
	
	end

	local d = 0;
	local i1 = ( type( self.NextReload ) == "number" );
	
	if( i1 ) then

		d = self.NextReload - CurTime();
		
	end
	
	local i2 = ( d > 0 );
	
	if( i1 and i2 ) then

		return false;
		
	end
	
	return true;
	
end
 
function SWEP:Reload() 

	if( self.IsMelee ) then
	
		return;
	
	end

    if( not self:CanReload() ) then

		return;
		
	end
    
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
	end
	
end 
 
function SWEP:SecondaryAttack() 

end 

function SWEP:CanFire()

	if( SERVER and self.Owner:GetPlayerHolstered() or CLIENT and ClientVars["Holstered"] ) then
	
		return false;
	
	end

	if( self.Weapon:Clip1() <= 0 ) then -- They're out of ammo
	
		self.Weapon:EmitSound( "Weapon_Pistol.Empty" );
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 );
		return false;
		
	end
	
	if( self.Owner:WaterLevel() >= 3 ) then -- They're underwater
	
		return false;
		
	end
	
	if( self.Owner.InStanceAction ) then
   	
   		return false;
   	
   	end
	
	return true;
	
end

function SWEP:PrimaryAttack() 

	if( SERVER and self.Owner:IsTied() ) then return; end
	
	if( not self:CanFire() ) then
	
		return; 
		
	end
	
	if( SERVER and self.Owner.InStanceAction ) then
	
		return;
		
	end
	
	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 140;
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );
	
	if self.Primary.DoorBreach then
	
		if( tr.Entity:IsValid() and tr.Entity:GetClass() == "prop_door_rotating" ) then
			
			tr.Entity:EmitSound( Sound(  "physics/wood/wood_box_impact_hard3.wav" ) );
		
			if( SERVER ) then

				local pos = tr.Entity:GetPos();
				local ang = tr.Entity:GetAngles();
				local model = tr.Entity:GetModel();
				local skin = tr.Entity:GetSkin();
				
				tr.Entity:SetNotSolid( true );
				tr.Entity:SetNoDraw( true );
				
				local function ResetDoor( door, fakedoor )
					door:SetNotSolid( false );
					door:SetNoDraw( false );
					fakedoor:Remove();
				end
				
				local norm = ( pos - self.Owner:GetPos() ):Normalize();
				local push = 10000 * norm;


				local ent = ents.Create( "prop_physics" );
				ent:SetPos( pos );
				ent:SetAngles( ang );
				ent:SetModel( model );
				if( skin ) then
					ent:SetSkin( skin );
				end
				ent:Spawn();
				
				timer.Simple( .2, ent.SetVelocity, ent, push );					
				timer.Simple( .2, ent:GetPhysicsObject().ApplyForceCenter, ent:GetPhysicsObject(), push );
															
				timer.Simple( 300, ResetDoor, tr.Entity, ent );
				
			end

		end
	
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if( not self.OwnerIsNPC ) then
		self:TakePrimaryAmmo( 1 ); -- NPCs get infinate ammo, as they don't know how to reload
	end
	
	self:ShootBullets();
	
end 

function SWEP:ShootBullets()

	local mul = 1;
	local minspread = Vector( 0.05, 0.05, 0.05 );

 	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 110 ) then
 		mul = 5;
 		minspread = Vector( .01, .01, .01 );
 	elseif( self.Owner:GetVelocity():Length() > 40 ) then
		mul = 2;
		minspread = Vector( .01, .01, .01 );
	end
	
	if( SERVER ) then
	
		if( self.Owner:GetPlayerDrunkMul() > 0 ) then
		
			mul = mul + self.Owner:GetPlayerDrunkMul() / .15;	
			minspread = Vector( .1, .1, .1 );
		
		end
		
	end
	
	if( self.Owner:KeyDown( IN_ATTACK2 ) ) then
	
		mul = mul * .7;
	
	end
	
	local bullet = { } 
 	bullet.Num 		= 8;
 	bullet.Src 		= self.Owner:GetShootPos();
 	bullet.Dir 		= self.Owner:GetAimVector()
 	bullet.Spread 	= self.Primary.SpreadCone + Vector( .04, .04, 0 );
 	bullet.Tracer	= 1;
 	bullet.Force	= .1;
 	bullet.Damage	= self.Primary.Damage;
 	bullet.TracerName = self.Primary.Tracer;
	bullet.Callback	= function( attacker, tr, dmginfo )

		local hit = EffectData();
		hit:SetOrigin( tr.HitPos );
		hit:SetNormal( tr.HitNormal );
		hit:SetScale( 20 );
		util.Effect( "effect_hit", hit );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsProp() ) then
		
			if( attacker:IsValid() and attacker:GetActiveWeapon():IsValid() ) then
			
				if( SERVER ) then
			
					if( CurTime() - attacker.LastAimProgress > 2 ) then
	
						if( math.random( 1, 2 ) == 2 ) then
				
							attacker:RaiseAimProgress( 1 );
				
						end
			
						attacker.LastAimProgress = CurTime();
			
					end
			
				end
		
			end
			
		end

		return true;
	
	end
 	
 	self.Owner:FireBullets( bullet );
 	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
 	self.Owner:MuzzleFlash();
 	self.Owner:SetAnimation( PLAYER_ATTACK1 );
 	
 	self.Weapon:EmitSound( self.Primary.Sound );
 	
 	self.Primary.Recoil = math.Clamp( self.Primary.Recoil + self.Primary.RecoilAdd, self.Primary.RecoilMin, self.Primary.RecoilMax );
 	
	self:ApplyRecoil();

end

function SWEP:ApplyRecoil()

 	local eyeang = Angle( self.Primary.Recoil * math.Rand( -1, .3 ), self.Primary.Recoil * math.Rand( -.7, .7 ), 0 );
 
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
SWEP.Primary.PositionMul = 1;

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
	
	if( self.Primary.PositionMode == 1 ) then
	
		if( self.Primary.IronSightPos ) then
 			pos, ang = self:GoIntoPosition( pos * 1, ang * 1, self.Primary.IronSightPos + self.Primary.PositionPosOffset, ( self.Primary.IronSightAng or Vector( 0, 0, 0 ) ) + self.Primary.PositionAngleOffset );
 	 	end
		
 	elseif( self.Primary.PositionMode == 2 or self.Primary.PositionMode == 3 ) then
	
 	 	if( self.Primary.HolsteredPos ) then
 			pos, ang = self:GoIntoPosition( pos * 1, ang * 1, self.Primary.HolsteredPos, self.Primary.HolsteredAng or Vector( 0, 0, 0 ) );
 	 	end
		
 	end
 	
 	return pos, ang;
 	
end

function SWEP:Think()

	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
			// Finsished reload -
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			// Next cycle
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			else
			
			end
			
			self.Weapon:EmitSound( Sound( "Weapon_Shotgun.Reload" ) );
			
		end
	
	end

end
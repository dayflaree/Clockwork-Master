--[[
	Free Clockwork!
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
end;

if (CLIENT) then
	SWEP.Slot = 4;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Tear Gas";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "Primary Fire: Throw.";
SWEP.Purpose = "Disorientating characters who enter its thick gas cloud.";
SWEP.Contact = "";
SWEP.Author	= "kurozael";

SWEP.WorldModel = "models/weapons/w_grenade.mdl";
SWEP.ViewModel = "models/weapons/v_grenade.mdl";

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 0;
SWEP.Primary.Delay = 1;
SWEP.Primary.Ammo = "grenade";

SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);

-- Called each frame.
function SWEP:Think()
	local curTime = CurTime();
	
	if (self.PulledBack and !self.Owner:KeyDown(IN_ATTACK)) then
		if (curTime >= self.PulledBack) then
			self.PulledBack = nil;
			self.Attacking = curTime + (self.Primary.Delay / 2);
			self.Raised = curTime + self.Primary.Delay + 2;
			
			if (!self.AttackTime) then
				self.AttackTime = curTime;
			end;
			
			self:CreateGrenade(math.Clamp(curTime - self.AttackTime, 0, 10) * 40);
			self:EmitSound("WeaponFrag.Throw");
			
			self:SendWeaponAnim(ACT_VM_THROW);
			self:SetNextPrimaryFire(curTime + self.Primary.Delay);
			
			self.Owner:SetAnimation(PLAYER_ATTACK1);
		end;
	elseif (type(self.Attacking) == "number") then
		if (curTime >= self.Attacking) then
			self.Attacking = nil;
			
			self:SendWeaponAnim(ACT_VM_DRAW);
			
			if (SERVER) then
				self.Owner:RemoveAmmo(1, "grenade");
				
				if (self.Owner:GetAmmoCount("grenade") == 0) then
					self.Owner:StripWeapon(self:GetClass());
				end;
			end;
		end;
	end;
end;

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	if (SERVER) then
		self:SetWeaponHoldType("grenade");
	end;
	
	self:SendWeaponAnim(ACT_VM_DRAW);
	
	self.PulledBack = nil;
	self.Attacking = nil;
end;

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	
	self.PulledBack = nil;
	self.Attacking = nil;
	
	return true;
end;

-- Called to get whether the SWEP is raised.
function SWEP:GetRaised()
	local curTime = CurTime();
	
	if (self.Attacking or (self.Raised and self.Raised > curTime)) then
		return true;
	end;
end;

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType("grenade");
	end;
end;

-- A function to create the SWEP's grenade.
function SWEP:CreateGrenade(power)
	if (SERVER) then
		local traceLine = self.Owner:GetEyeTraceNoCursor();
		local position = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 64);
		local entity = ents.Create("prop_physics");
		
		if (traceLine.HitPos:Distance(self.Owner:GetShootPos()) <= 80) then
			position = traceLine.HitPos - (self.Owner:GetAimVector() * 16);
		end;
		
		entity:SetModel("models/items/grenadeammo.mdl");
		entity:SetPos(position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			if (IsValid(entity:GetPhysicsObject())) then
				entity:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * (800 + power));
				entity:GetPhysicsObject():AddAngleVelocity(Angle(600, math.random(-1200, 1200), 0));
			end;
			
			local trail = util.SpriteTrail(entity, entity:LookupAttachment("fuse"), Color(255, 255, 50), true, 8, 1, 1, (1 / 9) * 0.5, "sprites/bluelaser1.vmt");
			
			if (IsValid(trail)) then
				entity:DeleteOnRemove(trail);
			end;
			
			timer.Simple(3, function()
				if (IsValid(entity)) then
					local effectData = EffectData();
					local entIndex = entity:EntIndex();
					local position = entity:GetPos();
					
					effectData:SetStart(position);
					effectData:SetOrigin(position);
					effectData:SetScale(16);
					
					util.Effect("Explosion", effectData, true, true);
					
					local effectData = EffectData();
						effectData:SetOrigin(position);
						effectData:SetScale(2);
					util.Effect("cw_smoke_effect", effectData, true, true);
					
					entity:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
					entity:Remove();
					
					Clockwork:CreateTimer("TearGas"..entIndex, 1, 0, function()
						local curTime = CurTime();
						
						for k, v in ipairs(ents.FindInSphere(position, 512)) do
							if (v:IsPlayer() and v:HasInitialized()) then
								if (Clockwork.player:CanSeePosition(v, position, 0.9, true)) then
									local itemTable = nil;
									
									if (!itemTable or !itemTable("tearGasProtection")) then
										if (!v.nextTearGas or curTime >= v.nextTearGas) then
											v.nextTearGas = curTime + 30;
											
											umsg.Start("cwTearGas", v);
											umsg.End();
										end;
									end;
								end;
							end;
						end;
					end);
				end;
			end);
		end;
	end;
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	local curTime = CurTime();
	
	if (!self.Attacking) then
		self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH);
		
		self.PulledBack = curTime + 0.157;
		self.AttackTime = curTime;
		self.Attacking = true;
	end;
	
	return false;
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack() end;
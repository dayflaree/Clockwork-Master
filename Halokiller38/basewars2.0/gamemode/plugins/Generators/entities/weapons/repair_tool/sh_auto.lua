if (CLIENT) then
	SWEP.PrintName = "Repair Tool";
	SWEP.Slot = 2;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
end;

SWEP.Author = "The Master";
SWEP.Instructions = "Left click to damage, right click to repair.";
SWEP.Contact = "";
SWEP.Purpose = "";

SWEP.ViewModelFOV = 50;
SWEP.ViewModelFlip = false;
SWEP.AnimPrefix	 = "rpg";

SWEP.ViewModel = "models/weapons/v_blowtortch.mdl";
SWEP.WorldModel = "models/weapons/w_blowtortch.mdl";

SWEP.Spawnable = false;
SWEP.AdminSpawnable = true;

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = true;
SWEP.Primary.Ammo = "";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = true;
SWEP.Secondary.Ammo = "";

SWEP.idleSound = "ambient/gas/steam_loop1.wav";
SWEP.activeSound = "ambient/energy/electric_loop.wav";

/*
Instructions:

idle ACT_VM_IDLE 
fire ACT_VM_PRIMARYATTACK 
fire_idle ACT_VM_DRYFIRE 
fire_stop ACT_VM_PULLBACK 
draw ACT_VM_DRAW
*/

function SWEP:Initialize()
	self:SetWeaponHoldType("normal");
	
	util.PrecacheSound(self.idleSound);
	util.PrecacheSound(self.activeSound);
	
	self.curPlaying = 0; -- 0 = none, 1 = idle, 2 = active;
	self.nextAction = CurTime();
	self.startTime = 0;
	self.useTime = 0;
end;

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
	self:SetNextPrimaryFire(CurTime() + 2);
end;

function SWEP:PrimaryAttack() end;
function SWEP:SecondaryAttack() end;

function SWEP:ShootEffects()
	
end;
function SWEP:Damage(trace, entity)

	
	if (SERVER) then
		local curTime = CurTime();
		
		if (ValidEntity(entity)) then
			if (self.curPlaying == 0 or self.curPlaying == 1) then
				if (self.curSound) then
					self.curSound:Stop();
				end;
				
				self.curSound = CreateSound(self.Owner, self.activeSound);
				self.curSound:ChangeVolume(0.5);
				self.curSound:Play();
				
				self.curPlaying = 2;
			end;
			
			if (entity.generator) then
				if (self.nextAction <= curTime) then
					RP.generator:Repair(entity, -0.5);
					self.nextAction = curTime + 0.1;
				end;
			elseif (entity:IsPlayer()) then
				entity:TakeDamage(1, self.Owner, self.Entity);
				self:SetNextPrimaryFire(curTime + 2);
			end;
			self:SparkEffect("damage");
		else
			if (self.curPlaying == 0 or self.curPlaying == 2) then
				if (self.curSound) then
					self.curSound:Stop();
				end;
				
				self.curSound = CreateSound(self.Owner, self.idleSound);
				self.curSound:ChangeVolume(0.5);
				self.curSound:Play();
				
				self.curPlaying = 1;
			end;
		end;
	end;
	
end;

function SWEP:Repair(trace, entity)
	
	if (SERVER) then
		local curTime = CurTime();
		
		if (ValidEntity(entity)) then
			if (self.curPlaying == 0 or self.curPlaying == 1) then
				if (self.curSound) then
					self.curSound:Stop();
				end;
				
				self.curSound = CreateSound(self.Owner, self.activeSound);
				self.curSound:ChangeVolume(0.3);
				self.curSound:Play();
				
				self.curPlaying = 2;
				
			end;
			if (entity.generator) then
				if (self.nextAction <= curTime) then
					RP.generator:Repair(entity, 1);
					self.nextAction = curTime + 0.1;
				end;
			end;
			
			self:SparkEffect("repair");
		else
			if (self.curPlaying == 0 or self.curPlaying == 2) then
				if (self.curSound) then
					self.curSound:Stop();
				end;
				
				self.curSound = CreateSound(self.Owner, self.idleSound);
				self.curSound:ChangeVolume(0.3);
				self.curSound:Play();
				
				self.curPlaying = 1;
			end;
		end;
	end;
end;

function SWEP:SparkEffect(weldType)
	if (!self.lastEffect or SysTime()-self.lastEffect >= 0.08) then
		self.lastEffect = SysTime()
		local tr = self.Owner:GetEyeTrace()
	 
		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude(1)
		effectdata:SetScale(2)
		effectdata:SetRadius(2)
		util.Effect("weld_"..weldType, effectdata, true, true)
	end;
end;

function SWEP:ResetMode()
	if (self.raised) then
		self:SetWeaponHoldType("normal");
		self:SendWeaponAnim(ACT_VM_IDLE);
		self.raised = false;
	end;
	
	self.startTime = 0;
	self.useTime = 0;
	
	if (SERVER) then
		self.curPlaying = 0;
		
		if (self.curSound) then
			self.curSound:Stop();
			self.curSound = nil;
		end;
	end;
end;

function SWEP:Think()
	if (self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2)) then
		if (self.startTime <= 0) then
			self.startTime = SysTime();
			if (!self.raised) then
				self:SetWeaponHoldType("pistol");
				self:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
				self.raised = true;
			end;
		end;
		self.useTime = SysTime() - self.startTime;
	else 
		self:ResetMode();
	end;
	
	if (self.useTime >= 0.5) then
		if (self.Owner:KeyDown(IN_ATTACK) and self:GetNextPrimaryFire() <= CurTime()) then
			local trace = self.Owner:EyeTrace(50);
			local entity = trace.Entity;
			
			self:Damage(trace, entity);

		elseif (self.Owner:KeyDown(IN_ATTACK2) and self:GetNextPrimaryFire() <= CurTime()) then
			local trace = self.Owner:EyeTrace(50);
			local entity = trace.Entity;
			
			self:Repair(trace, entity);
		end;
	end;
end;

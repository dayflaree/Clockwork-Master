if (SERVER) then
	AddCSLuaFile("shared.lua");
end;

if (CLIENT) then
	SWEP.Slot = 0;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Shank";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "LMB to piss people off.";
SWEP.Purpose = "A makeshift shank, ideal for killing the compines.";
SWEP.Contact = "";
SWEP.Author	= "Zak";

SWEP.WorldModel = "models/weapons/w_knife_ct.mdl";
SWEP.ViewModel = "models/weapons/v_knife_t.mdl";
SWEP.HoldType = "knife";
SWEP.ViewModelFOV = 80;

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = true;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 3;
SWEP.Primary.Delay = 0.7;
SWEP.Primary.Ammo = "";

SWEP.Secondary.NeverRaised = true;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);

SWEP.VElements = {
	["cloth"] = { type = "Model", model = "models/weapons/w_eq_eholster.mdl", bone = "v_weapon.knife_Parent", rel = "", pos = Vector(0.111, -0.348, 2.016), angle = Angle(-88.95, -85.585, -0.654), size = Vector(0.356, 0.342, 0.365), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/FurnitureFabric003a", skin = 0, bodygroup = {} },
	["glass"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "v_weapon.knife_Parent", rel = "", pos = Vector(-0.473, -4.108, 2.01), angle = Angle(88.474, -0.732, 14.876), size = Vector(0.37, 0.37, 0.37), color = Color(255, 255, 255, 200), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
};
SWEP.WElements = {
	["cloth"] = { type = "Model", model = "models/props_debris/concrete_chunk04a.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.81, 0.398, -0.004), angle = Angle(-145.584, 58.981, 76.778), size = Vector(0.614, 0.621, 0.143), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_c17/FurnitureFabric003a", skin = 0, bodygroup = {} },
	["glass"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(0.326, -2.557, 0), angle = Angle(86.204, 0, -18.042), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 200), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
};

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
end;

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	
	return true;
end;

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType);
end;

-- A function to do the SWEP's hit effects.
function SWEP:DoHitEffects()
	local trace = self.Owner:GetEyeTraceNoCursor();
	
	if (((trace.Hit or trace.HitWorld) and self.Owner:GetShootPos():Distance(trace.HitPos) <= 64)) then
		self:SendWeaponAnim(ACT_VM_HITCENTER);
		self:EmitSound("weapons/crossbow/hitbod2.wav");
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("npc/vort/claw_swing2.wav");
	end;
end;

-- A function to do the SWEP's animations.
function SWEP:DoAnimations(idle)
	if (!idle) then
		self.Owner:SetAnimation(PLAYER_ATTACK1);
	end;
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay);
	
	self:DoAnimations(); self:DoHitEffects();
	
	if (SERVER) then
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(true);
		end;
		
		local trace = self.Owner:GetEyeTraceNoCursor();
		
		if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 64) then
			if (IsValid(trace.Entity)) then
				local player = Clockwork.entity:GetPlayer(trace.Entity);
				local strength = Clockwork.attributes:Fraction(self.Owner, ATB_STRENGTH, 10, 5);
				
				if (trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then
					local normal = (trace.Entity:GetPos() - self.Owner:GetPos()):GetNormal();
					local push = 128 * normal;
					
					trace.Entity:SetVelocity(push);
					
					timer.Simple(FrameTime() * 0.5, function()
						if (IsValid(trace.Entity)) then
							trace.Entity:TakeDamageInfo(Clockwork.kernel:FakeDamageInfo(self.Primary.Damage + strength, self, self.Owner, trace.HitPos, DMG_CLUB, 2));
						end;
					end);
					
					self.Owner:ProgressAttribute(ATB_STRENGTH, 1, true);
				else
					local physicsObject = trace.Entity:GetPhysicsObject();
					
					if (IsValid(physicsObject)) then
						physicsObject:ApplyForceOffset(self.Owner:GetAimVector() * math.max(math.min(physicsObject:GetMass(), 100) * 10, 1024), trace.HitPos);
						
						if (!player) then
							timer.Simple(FrameTime() * 0.5, function()
								if (IsValid(trace.Entity)) then
									trace.Entity:TakeDamageInfo(Clockwork.kernel:FakeDamageInfo((self.Primary.Damage * 2) + strength, self, self.Owner, trace.HitPos, DMG_CLUB, 2));
								end;
							end);
							
							self.Owner:ProgressAttribute(ATB_STRENGTH, 0.5, true);
						else
							timer.Simple(FrameTime() * 0.5, function()
								if (IsValid(trace.Entity)) then
									trace.Entity:TakeDamageInfo(Clockwork.kernel:FakeDamageInfo(self.Primary.Damage + strength, self, self.Owner, trace.HitPos, DMG_CLUB, 2));
								end;
							end);
							
							self.Owner:ProgressAttribute(ATB_STRENGTH, 1, true);
						end;
					end;
				end;
			else
				self.Owner:FireBullets({
					Spread = Vector(0, 0, 0),
					Damage = 1,
					Tracer = 0,
					Force = 1,
					Num = 1,
					Src = self.Owner:GetShootPos(),
					Dir = self.Owner:GetAimVector()
				});
			end;
		end;
		
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(false);
		end;
	end;
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack() end;
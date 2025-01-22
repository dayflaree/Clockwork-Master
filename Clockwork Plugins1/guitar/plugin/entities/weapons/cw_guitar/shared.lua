local Clockwork = Clockwork;

if (SERVER) then
	AddCSLuaFile("shared.lua");
	
	SWEP.ActivityTranslate = {
		[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_FIST,
		[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_FIST,
		[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_CROUCH_FIST,
		[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK1,
		[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_FIST,
		[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_FIST,
		[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_FIST,
		[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_FIST
	};
end;

if (CLIENT) then
	SWEP.Slot = 5;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Guitar";
	SWEP.DrawCrosshair = false;
end

SWEP.Instructions = "Primary Fire: Play a song.\nSecondary Fire: Stop playing.\nCannot be holstered while playing.";
SWEP.Contact = "";
SWEP.Purpose = "For playin' songs around the campfire.";
SWEP.Author	= "RJ";

SWEP.WorldModel = "models/weapons/w_fists_t.mdl";
SWEP.ViewModel = "models/weapons/v_punch.mdl";
SWEP.HoldType = "melee";

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;

SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Delay = 0.25;
SWEP.Primary.Ammo = "";

SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.LoweredAngles = Angle(60, 60, 60);
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType);
	self.nextPlay = CurTime() + self.Primary.Delay;
	self.songInt = 0;
	
	--self.Song = CreateSound(self, "stalker_guitar/"..self.songInt..".mp3");
end;

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
	
	Clockwork.player:SetWeaponRaised(self.Owner, true)
end;

-- Called when the SWEP is holstered.
function SWEP:Holster()
	--[[if (self.Song != nil) then
		if (self.Song:IsPlaying()) then
			Clockwork.player:Notify(player, "You cannot change weapons while playing the guitar!");
			
			return;
		end;
	end;]]--
	
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	return true;
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	if (CurTime() <= self.nextPlay) then return end;
	
	if (self.songInt != 25) then
		self.songInt = self.songInt + 1;
	else
		self.songInt = 1;
	end;
	
	self:EmitSound("stalker_guitar/"..self.songInt..".mp3");
	
	self.nextPlay = CurTime() + self.Primary.Delay;
end;

--[[ Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	if (CurTime() <= self.nextPlay) then return end;
	
	if (self.Song:IsPlaying()) then
		self.Song:Stop();
	end;
	
	if (self.songInt != 9) then
		self.songInt = self.songInt + 1;
	else
		self.songInt = 1;
	end;
	
	self.Song = CreateSound(self, "stalker_guitar/"..self.songInt..".mp3");
	
	self.Song:Play();
	print("Track "..self.songInt.." played.");
	self.nextPlay = CurTime() + self.Primary.Delay;
end;]]--

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	--self.Song:Stop();
end;
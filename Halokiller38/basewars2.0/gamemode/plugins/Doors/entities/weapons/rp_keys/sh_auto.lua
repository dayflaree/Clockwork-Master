if (CLIENT) then
	SWEP.PrintName = "Keys"
	SWEP.Slot = 2
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Spencer Sharkey"
SWEP.Instructions = "Left click to lock a door, Right click to unlock it."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	if (SERVER) then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	if (SERVER) then
		local entity = self.Owner:GetEyeTraceNoCursor().Entity;
		if (ValidEntity(entity)) then
			if (entity:GetPos():Distance(self.Owner:GetPos()) <= 128) then
				if (string.find(string.lower(entity:GetClass()), "door")) then
					if (self.Owner:HasDoorAccess(entity)) then
						entity:Fire("lock", "", 0);
						timer.Simple(0.2, function(ply, sound) if ValidEntity(ply) then ply:EmitSound(sound) end end, self.Owner, self.Sound);
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_ITEM_PLACE);
						self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
					end;
				end;
			end;
		end;
	end;
end;

function SWEP:SecondaryAttack()
	if (SERVER) then
		local entity = self.Owner:GetEyeTraceNoCursor().Entity;
		if (ValidEntity(entity)) then
			if (entity:GetPos():Distance(self.Owner:GetPos()) <= 128) then
				if (string.find(string.lower(entity:GetClass()), "door")) then
					if (self.Owner:HasDoorAccess(entity)) then
						entity:Fire("unlock", "", 0);
						timer.Simple(0.2, function(ply, sound) if ValidEntity(ply) then ply:EmitSound(sound) end end, self.Owner, self.Sound);
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_ITEM_PLACE);
						self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
					end;
				end;
			end;
		end;
	end;
end;

function SWEP:Reload()

end

--[[
	Free Clockwork!
--]]

PLUGIN.BoneHoldTypes = {
	["none"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1",
		"ValveBiped.Bip01_Spine4",
		"ValveBiped.Bip01_Spine2",
	},
	["fist"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1",
		"ValveBiped.Bip01_Spine4",
		"ValveBiped.Bip01_Spine2",
	},
	["chair"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1",
		"ValveBiped.Bip01_Spine4",
		"ValveBiped.Bip01_Spine2",
		"ValveBiped.Bip01_R_Upperarm",
		"ValveBiped.Bip01_L_Upperarm",
		"ValveBiped.Bip01_R_Clavicle",
		"ValveBiped.Bip01_L_Clavicle"
	},
	["default"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1",
		"ValveBiped.Bip01_Spine4",
		"ValveBiped.Bip01_Spine2",
		"ValveBiped.Bip01_L_Hand",
		"ValveBiped.Bip01_L_Forearm",
		"ValveBiped.Bip01_L_Upperarm",
		"ValveBiped.Bip01_L_Clavicle",
		"ValveBiped.Bip01_R_Hand",
		"ValveBiped.Bip01_R_Forearm",
		"ValveBiped.Bip01_R_Upperarm",
		"ValveBiped.Bip01_R_Clavicle"
	},
	["vehicle"] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1",
		"ValveBiped.Bip01_Spine4",
		"ValveBiped.Bip01_Spine2",
	}
};

PLUGIN.PlaybackRate = 1;
PLUGIN.OldWeapon = nil;
PLUGIN.Sequence = nil;
PLUGIN.Velocity = 0;
PLUGIN.HoldType = nil;

PLUGIN.ForwardOffset = -24;
PLUGIN.BonesToRemove = {};
PLUGIN.RenderAngle = nil;
PLUGIN.RenderColor = {};
PLUGIN.BreathScale = 0.5;
PLUGIN.BoneMatrix = nil;
PLUGIN.NextBreath = 0;
PLUGIN.BiaisAngle = nil;
PLUGIN.ClipVector = vector_up * -1;
PLUGIN.RenderPos = nil;
PLUGIN.RadAngle = nil;

-- A function to get whether the legs should be drawn.
function PLUGIN:ShouldDrawLegs()
	return IsValid(self.LegsEntity) and Clockwork.Client:Alive()
	and self:CheckDrawVehicle() and GetViewEntity() == Clockwork.Client
	and !Clockwork.Client:ShouldDrawLocalPlayer() and !Clockwork.Client:GetObserverTarget();
end;

-- A function to check if a vehicle should be drawn.
function PLUGIN:CheckDrawVehicle()
	return Clockwork.Client:InVehicle() and !gmod_vehicle_viewmode:GetBool() or !Clockwork.Client:InVehicle();
end;

-- A function to create the legs.
function PLUGIN:CreateLegs()
	self.LegsEntity = ClientsideModel(Clockwork.Client:GetModel(), RENDER_GROUP_OPAQUE_ENTITY);
	self.LegsEntity:SetNoDraw(true);
	self.LegsEntity:SetSkin(Clockwork.Client:GetSkin());
	self.LegsEntity:SetMaterial(Clockwork.Client:GetMaterial());
	self.LegsEntity.LastTick = 0;
end;

-- A function to get when a weapon is changed.
function PLUGIN:WeaponChanged(weapon)
	if (IsValid(self.LegsEntity)) then
		if (IsValid(weapon)) then
			self.HoldType = weapon:GetHoldType();
		else
			self.HoldType = "none";
		end;
		
		self.LegsEntity.BuildBonePositions = function(numBones, numPhysBones)
			self.BonesToRemove = {"ValveBiped.Bip01_Head1"};
			
			if (!Clockwork.Client:InVehicle()) then
				if ((self.HoldType != "fist" or !Clockwork.player:GetWeaponRaised(Clockwork.Client))
				and self.BoneHoldTypes[self.HoldType]) then
					self.BonesToRemove = self.BoneHoldTypes[self.HoldType];
				else
					self.BonesToRemove = self.BoneHoldTypes["default"];
				end;
			elseif ( !Clockwork.entity:IsChairEntity( Clockwork.Client:GetVehicle() ) ) then
				self.BonesToRemove = self.BoneHoldTypes["vehicle"];
			else
				self.BonesToRemove = self.BoneHoldTypes["chair"];
			end;
			
			for k, v in ipairs(self.BonesToRemove) do
				self.BoneMatrix = self.LegsEntity:GetBoneMatrix(self.LegsEntity:LookupBone(v));
				
				if (self.BoneMatrix) then
					self.BoneMatrix:Scale(vector_origin);
					self.LegsEntity:SetBoneMatrix(self.LegsEntity:LookupBone(v), self.BoneMatrix);
				end;
			end;
		end;
	end;
end;

-- Called every frame for the legs.
function PLUGIN:LegsThink(maxSeqGroundSpeed)
	local curTime = CurTime();
	
	if (IsValid(self.LegsEntity)) then
		if (Clockwork.Client:GetActiveWeapon() != self.OldWeapon) then
			self.OldWeapon = Clockwork.Client:GetActiveWeapon();
			self:WeaponChanged(self.OldWeapon);
		end;
		
		if (self.LegsEntity:GetModel() != Clockwork.Client:GetModel()) then
			self.LegsEntity:SetModel(Clockwork.Client:GetModel());
		end
		
		self.LegsEntity:SetMaterial(Clockwork.Client:GetMaterial());
		self.LegsEntity:SetSkin(Clockwork.Client:GetSkin());
		self.Velocity = Clockwork.Client:GetVelocity():Length2D();
		self.PlaybackRate = 1;

		if (self.Velocity > 0.5) then
			if (maxSeqGroundSpeed < 0.001) then
				self.PlaybackRate = 0.01;
			else
				self.PlaybackRate = self.Velocity / maxSeqGroundSpeed;
				self.PlaybackRate = math.Clamp(self.PlaybackRate, 0.01, 10);
			end
		end
		
		self.LegsEntity:SetPlaybackRate(self.PlaybackRate);
		self.Sequence = Clockwork.Client:GetSequence();
		
		if (self.LegsEntity.Anim != self.Sequence) then
			self.LegsEntity.Anim = self.Sequence;
			self.LegsEntity:ResetSequence(self.Sequence);
		end;
		
		self.LegsEntity:FrameAdvance(curTime - self.LegsEntity.LastTick);
		self.LegsEntity.LastTick = curTime;
		
		if (self.NextBreath <= curTime) then
			self.NextBreath = curTime + 1.95 / self.BreathScale;
			self.LegsEntity:SetPoseParameter("breathing", self.BreathScale);
		end
		
		self.LegsEntity:SetPoseParameter("move_yaw", (Clockwork.Client:GetPoseParameter("move_yaw") * 360) - 180);
		self.LegsEntity:SetPoseParameter("body_yaw", (Clockwork.Client:GetPoseParameter("body_yaw") * 180) - 90);
		self.LegsEntity:SetPoseParameter("spine_yaw", (Clockwork.Client:GetPoseParameter("spine_yaw") * 180) - 90)
		
		if (Clockwork.Client:InVehicle()) then
			self.LegsEntity:SetColor(color_transparent);
			self.LegsEntity:SetPoseParameter("vehicle_steer", (Clockwork.Client:GetVehicle():GetPoseParameter("vehicle_steer") * 2) - 1);
		end;
	end;
end;

local PLUGIN = PLUGIN;

local entityMeta = FindMetaTable("Entity");
local playerMeta = FindMetaTable("Player");

local randomSounds = {
	"physics/wood/wood_plank_break1.wav",
	"physics/wood/wood_box_break1.wav",
	"physics/wood/wood_crate_break3.wav",
	"physics/wood/wood_crate_break4.wav",
	"physics/wood/wood_crate_break5.wav",
	"physics/wood/wood_furniture_break1.wav"
};

function entityMeta:IsDoor()
	return self:GetClass() == "prop_door_rotating" or self:GetClass() == "func_door";
end;

function entityMeta:GetDoorPartner()
	if (!self:IsDoor()) then
		ErrorNoHalt("Attempt to get partner of a non-door entity.");
	end;

	local partners = {}

	for k, v in pairs(ents.FindByName(self:GetName())) do
		if (v != self and v:IsDoor()) then
			partners[#partners + 1] = v;
		end;
	end;

	return partners;
end;

function entityMeta:BlastDoor(velocity, restoreDelay, dummyLife, ignorePartner)
	if (!self:IsDoor()) then return; end;
	if (self.kicked) then return; end;

	if (IsValid(self.Dummy)) then
		self.Dummy:Remove();
	end;

	velocity = velocity or VectorRand() * 100;
	restoreDelay = restoreDelay or 120;
	dummyLife = dummyLife or 5;

	if (!ignorePartner) then
		for k, v in pairs(self:GetDoorPartner()) do
			if (IsValid(v)) then
				v:BlastDoor(velocity, restoreDelay, dummyLife, true);
			end;
		end;
	end;

	local rand = table.Random(randomSounds);
	self:EmitSound(rand);

	local color = self:GetColor();
	local dummy = ents.Create("prop_physics");
	dummy:SetModel(self:GetModel());
	dummy:SetPos(self:GetPos());
	dummy:SetAngles(self:GetAngles());
	dummy:Spawn();
	dummy:SetColor(color);
	dummy:SetMaterial(self:GetMaterial());
	dummy:SetSkin(self:GetSkin() or 0);
	dummy:SetRenderMode(RENDERMODE_TRANSALPHA);
	dummy:SetOwner(self);
	dummy:SetCollisionGroup(COLLISION_GROUP_WEAPON);
	self:Fire("unlock");
	self:Fire("open");
	self:SetNotSolid(true);
	self:SetNoDraw(true);
	self:DrawShadow(false);
	self.ignoreUse = true;
	self.Dummy = dummy;
	self.kicked = true;
	self:DeleteOnRemove(dummy);

	for k, v in ipairs(self:GetBodyGroups()) do
		dummy:SetBodygroup(v.id, self:GetBodygroup(v.id));
	end;

	for k, v in ipairs(ents.GetAll()) do
		if (v:GetParent() == self) then
			v:SetNotSolid(true);
			v:SetNoDraw(true);
		end;
	end;

	dummy:GetPhysicsObject():SetVelocity(velocity);
	local uniqueID = "doorRestore" .. self:EntIndex();
	local uniqueID2 = "doorOpener" .. self:EntIndex();

	timer.Create(uniqueID2, 1, 0, function()
		if (IsValid(self) and IsValid(self.Dummy)) then
			self:Fire("open");
		else
			timer.Remove(uniqueID2);
		end;
	end);

	timer.Create(uniqueID, dummyLife, 1, function()
		if (IsValid(self) and IsValid(dummy)) then
			uniqueID = "dummyFade" .. dummy:EntIndex()
			local alpha = 255;

			timer.Create(uniqueID, 0.008, 255, function()
				if (IsValid(dummy)) then
					alpha = alpha - 1;
					dummy:SetColor(ColorAlpha(color, alpha));

					if (alpha <= 0) then
						dummy:Remove();
					end;
				else
					timer.Remove(uniqueID);
				end;
			end);
		end;
	end);

	timer.Create(uniqueID .. self:EntIndex(), restoreDelay, 1, function()
		if (IsValid(self)) then
			self:SetNotSolid(false);
			self:SetNoDraw(false);
			self:DrawShadow(true);
			self.ignoreUse = false;
			self.kicked = false;

			for k, v in ipairs(ents.GetAll()) do
				if (v:GetParent() == self) then
					v:SetNotSolid(false);
					v:SetNoDraw(false);
				end;
			end;
		end;
	end);

	return dummy;
end;

function playerMeta:KickDoor(door)
	if (!IsValid(door)) then return; end;
	local animClass = Clockwork.animation:GetModelClass(self:GetModel());
	local sequence = "kickdoorbaton";

	self:SetNoDraw(true);
	self:Freeze(true);
	self:SetSharedVar("KickingDoor", true);

	local anim = ents.Create("prop_dynamic");
	anim:SetModel(self:GetModel());
	anim:SetPos(self:GetPos());
	anim:SetAngles(self:GetAngles());
	anim:SetNotSolid(true);

	if (animClass == "combineOverwatch") then
		sequence = "melee_gunhit";
	end;

	anim:Fire("SetAnimation", sequence);

	timer.Simple(0.9, function()
		if (IsValid(door)) then
			local chance = math.random(1, 100);

			if (self:GetFaction() == FACTION_OTA or (chance + (Clockwork.attributes:Fraction(self, ATB_STRENGTH, 100) / 2) >= 65)) then
				door:BlastDoor(self:GetEyeTrace().HitNormal * - 250, 60, 20);
			else
				local rand = table.Random(randomSounds);

				door:EmitSound(rand);
			end;
		end;
	end);

	timer.Simple(1.75, function()
		if (IsValid(self)) then
			self:SetSharedVar("KickingDoor", false);
			self:SetNoDraw(false);
			self:Freeze(false);
		end;
	end);

	SafeRemoveEntityDelayed(anim, 1.8);
end;
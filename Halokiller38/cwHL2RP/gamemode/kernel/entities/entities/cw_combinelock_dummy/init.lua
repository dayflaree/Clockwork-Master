--[[
	Free Clockwork!
--]]

Clockwork:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_combine/combine_lock01.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetHealth(800);
	self:SetSolid(SOLID_VPHYSICS);
	
	local physicsObject = self:GetPhysicsObject();
	
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

function ENT:SetDoor(entity)
	self.entity = entity;
	self.entity:DeleteOnRemove(self);
	self.entities = {entity};
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- Called each frame.
function ENT:Think()
	if (!IsValid(self.entity)) then
		self:Explode(); self:Remove();
	end;
	self:NextThink(CurTime() + 0.1);
end;

-- A function to toggle whether the entity is locked.
function ENT:Toggle()
	if ( self:IsLocked() ) then
		self:Unlock();
	else
		self:Lock();
	end;
end;

-- A function to lock the entity.
function ENT:Lock()
	self:SetDTBool("locked", true);
	self:GetParent():Lock();
end;

-- A function to unlock the entity.
function ENT:Unlock()
	self:SetDTBool("locked", false);
	self:GetParent():Unlock();
end;

-- A function to set the entity's flash duration.
function ENT:SetFlashDuration(duration)
	self:EmitSound("buttons/combine_button_locked.wav");
	self:SetDTFloat("flash", CurTime() + duration);
	self:GetParent():SetDTFloat("flash", CurTime() + duration);
end;

-- A function to activate the entity's smoke charge.
function ENT:ActivateSmokeCharge(force)
	Clockwork:CreateTimer("dumm_removal_"..self:EntIndex(), 12, 1, function()
		if ( IsValid(self) ) then
			self:Explode();
		end;
	end);
end;

-- A function to explode the entity.
function ENT:Explode()
	local effectData = EffectData();
	effectData:SetStart( self:GetPos() );
	effectData:SetOrigin( self:GetPos() );
	effectData:SetScale(1);
	util.Effect("Explosion", effectData, true, true);
	self:Remove();
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	self:Explode(); self:Unlock();
	
	if (self.entities) then
		
		for k, v in ipairs(self.entities) do
			if ( IsValid(v) ) then
				v:Fire("Unlock", "", 0);
			end;
		end;
	end;
end;

-- A function to toggle the entity with checks.
function ENT:ToggleWithChecks(activator)
	local curTime = CurTime();
	
	if (!self.nextUse or curTime >= self.nextUse) then
		if ( curTime > self:GetParent():GetDTFloat("flash") ) then
			if ( curTime > self:GetParent():GetDTFloat("smokeCharge") ) then
				self.nextUse = curTime + 3;
				
				if (!Clockwork.schema:PlayerIsCombine(activator) and activator:QueryCharacter("faction") != FACTION_CITYADMIN) then
					self:SetFlashDuration(3);
				else
					self:Toggle();
				end;
			end;
		end;
	end;
end;

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
		self:ToggleWithChecks(activator);
	end;
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	self:GetParent():SetHealth(math.max(self:GetParent():Health() - damageInfo:GetDamage(), 0));
end;

-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;
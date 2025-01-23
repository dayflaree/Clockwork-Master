--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when a player's character has unloaded.
function PLUGIN:PlayerCharacterUnloaded(player)
	self:ForceDropEntity(player);
end;

-- Called when a player attempts to throw a punch.
function PLUGIN:PlayerCanThrowPunch(player)
	if (IsValid(player.cwHoldingEnt) or (player.nextPunchTime
	and player.nextPunchTime >= CurTime())) then
		return false;
	end;
end;

-- Called when a player's weapons should be given.
function PLUGIN:PlayerGiveWeapons(player)
	if (Clockwork.config:Get("take_physcannon"):Get()) then
		Clockwork.player:TakeSpawnWeapon(player, "weapon_physcannon");
	end;
end;

-- Called to get whether an entity is being held.
function PLUGIN:GetEntityBeingHeld(entity)
	if (IsValid(entity.cwHoldingGrab) and !entity:IsPlayer()) then
		return true;
	end;
end;

-- Called when Clockwork config has changed.
function PLUGIN:ClockworkConfigChanged(key, data, previousValue, newValue)
	if (key == "take_physcannon") then
		
		for k, v in ipairs(_player.GetAll()) do
			if (newValue) then
				Clockwork.player:TakeSpawnWeapon(v, "weapon_physcannon");
			else
				Clockwork.player:GiveSpawnWeapon(v, "weapon_physcannon");
			end;
		end;
	end;
end;

-- Called when a player's ragdoll attempts to take damage.
function PLUGIN:PlayerRagdollCanTakeDamage(player, ragdoll, inflictor, attacker, hitGroup, damageInfo)
	if (ragdoll.cwNextTakeDmg and CurTime() < ragdoll.cwNextTakeDmg) then
		return false;
	elseif (IsValid(ragdoll.cwHoldingGrab)) then
		if (!damageInfo:IsExplosionDamage() and !damageInfo:IsBulletDamage()) then
			if (!damageInfo:IsDamageType(DMG_CLUB) and !damageInfo:IsDamageType(DMG_SLASH)) then
				return false;
			end;
		end;
	end;
end;

-- Called when a player attempts to get up.
function PLUGIN:PlayerCanGetUp(player)
	if (player:GetSharedVar("IsDragged")) then
		return false;
	end;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	if (player:IsRagdolled() and Clockwork.player:GetUnragdollTime(player)) then
		local entity = player:GetRagdollEntity();
		
		if (IsValid(entity)) then
			if (IsValid(entity.cwHoldingGrab) or entity:IsBeingHeld()) then
				Clockwork.player:PauseUnragdollTime(player);
				
				player:SetSharedVar("IsDragged", true);
			elseif (player:GetSharedVar("IsDragged")) then
				Clockwork.player:StartUnragdollTime(player);
				
				player:SetSharedVar("IsDragged", false);
			end;
		else
			player:SetSharedVar("IsDragged", false);
		end;
	else
		player:SetSharedVar("IsDragged", false);
	end;
end;

-- Called when a player presses a key.
function PLUGIN:KeyPress(player, key)
	if (player:IsUsingHands()) then
		if (!IsValid(player.cwHoldingEnt)) then
			if (key == IN_ATTACK2) then
				local trace = player:GetEyeTraceNoCursor();
				local entity = trace.Entity;
				local bCanPickup = nil;
				
				if (IsValid(entity) and trace.HitPos:Distance(player:GetShootPos()) <= 192
				and !entity:IsPlayer() and !entity:IsNPC()) then
					if (IsValid(entity:GetPhysicsObject()) and entity:GetSolid() == SOLID_VPHYSICS) then
						if (entity:GetClass() == "prop_ragdoll" or entity:GetPhysicsObject():GetMass() <= 100) then
							if (entity:GetPhysicsObject():IsMoveable() and !IsValid(entity.cwHoldingGrab)) then
								bCanPickup = true;
							end;
						end;
					end;
					
					if (bCanPickup and !Clockwork.entity:IsDoor(entity)) then
						self:ForcePickup(player, entity, trace);
					end;
				end;
			end;
		elseif (key == IN_ATTACK) then
			self:ForceThrowEntity(player);
		elseif (key == IN_RELOAD) then
			self:ForceDropEntity(player);
		end;
	end;
end;
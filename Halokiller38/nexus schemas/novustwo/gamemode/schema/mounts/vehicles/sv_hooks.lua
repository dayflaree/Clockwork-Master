--[[
Name: "sv_hooks.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

-- A function to scale damage by hit group.
function MOUNT:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	if ( player:InVehicle() ) then
		local damagePosition = damageInfo:GetDamagePosition();
		local vehicle = player:GetVehicle();
		
		if (vehicle.ItemTable) then
			if ( player:GetPos():Distance(damagePosition) > 96
			and !damageInfo:IsExplosionDamage() ) then
				damageInfo:SetDamage(0);
			end;

			if (vehicle.IsLocked) then
				vehicle.IsLocked = false;
				vehicle:EmitSound("doors/door_latch3.wav");
				vehicle:Fire("unlock", "", 0);
			end;
			
			if (vehicle.Passengers) then
				timer.Simple(FrameTime() * 0.5, function()
					if ( IsValid(vehicle) and IsValid(player) ) then
						for k, v in pairs(vehicle.Passengers) do
							if ( IsValid(v) ) then
								local driver = v:GetDriver();

								if (IsValid(driver) and driver != player) then
									if ( driver:GetPos():Distance(damagePosition) <= 96
									or damageInfo:IsExplosionDamage() ) then
										damageInfo:SetDamage(baseDamage);

										driver:TakeDamageInfo(damageInfo);
									end;
								end;
							end;
						end;
					end;
				end);
			end;
		end;
	elseif ( ( attacker:IsPlayer() and attacker:InVehicle() )
	or attacker:IsVehicle() ) then
		if (baseDamage >= 50) then
			nexus.player.SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 20);
			
			damageInfo:ScaleDamage(0.5);
		end;
	end;
end;

-- Called when a player's character has loaded.
function MOUNT:PlayerCharacterLoaded(player)
	player.vehicles = {};
end;

-- Called when a player attempts to pickup an entity with the physics gun.
function MOUNT:PhysgunPickup(player, entity)
	if ( entity:IsVehicle() and entity.ItemTable and !player:IsUserGroup("operator") and !player:IsAdmin() ) then
		return false;
	end;
end;

-- Called when a player's inventory string is needed.
function MOUNT:PlayerGetInventoryString(player, character, inventory)
	if (player.vehicles) then
		for k, v in pairs(player.vehicles) do
			if ( IsValid(k) ) then
				if ( inventory[v.uniqueID] ) then
					inventory[v.uniqueID] = inventory[v.uniqueID] + 1;
				else
					inventory[v.uniqueID] = 1;
				end;
			end;
		end;
	end;
end;

-- Called when a player attempts to lock an entity.
function MOUNT:PlayerCanLockEntity(player, entity)
	if (entity:IsVehicle() and entity.ItemTable) then
		return nexus.entity.GetOwner(entity) == player;
	end;
end;

-- Called when a player attempts to unlock an entity.
function MOUNT:PlayerCanUnlockEntity(player, entity)
	if (entity:IsVehicle() and entity.ItemTable) then
		return nexus.entity.GetOwner(entity) == player;
	end;
end;

-- Called when a player's unlock info is needed.
function MOUNT:PlayerGetUnlockInfo(player, entity)
	if (entity:IsVehicle() and entity.ItemTable) then
		return {
			duration = nexus.config.Get("unlock_time"):Get(),
			Callback = function(player, entity)
				entity.IsLocked = false;
				entity:Fire("unlock", "", 0);
			end
		};
	end;
end;

-- Called when a player's lock info is needed.
function MOUNT:PlayerGetLockInfo(player, entity)
	if (entity:IsVehicle() and entity.ItemTable) then
		return {
			duration = nexus.config.Get("lock_time"):Get(),
			Callback = function(player, entity)
				entity.IsLocked = true;
				entity:Fire("lock", "", 0);
			end
		};
	end;
end;

-- Called when a player has disconnected.
function MOUNT:PlayerCharacterUnloaded(player)
	if (player.vehicles) then
		for k, v in pairs(player.vehicles) do
			if ( IsValid(k) ) then
				k:Remove();
			end;
		end;
	end;
end;

-- Called when a player leaves a vehicle.
function MOUNT:PlayerLeaveVehicle(player, vehicle)
	player.nextEnterVehicle = CurTime() + 2;
	player:SetVelocity( Vector(0, 0, 0) );

	timer.Simple(FrameTime() * 2, function()
		if ( IsValid(player) and IsValid(vehicle) and !player:InVehicle() ) then
			self:MakeExitVehicle(player, vehicle);
		end;
	end);
end;

-- Called when a player attempts to enter a vehicle.
function MOUNT:CanPlayerEnterVehicle(player, vehicle, role)
	if ( player.nextEnterVehicle and player.nextEnterVehicle >= CurTime() ) then
		return false;
	end;

	if (vehicle.IsLocked) then
		return false;
	end;
end;

-- Called when a player attempts to exit a vehicle.
function MOUNT:CanExitVehicle(vehicle, player)
	if ( player.nextExitVehicle and player.nextExitVehicle >= CurTime() ) then
		return false;
	end;

	local parentVehicle = vehicle:GetParent();

	if (IsValid(parentVehicle) and parentVehicle.ItemTable) then
		return false;
	end;

	if (vehicle.IsLocked) then
		return false;
	end;
end;

-- Called when a player presses a key.
function MOUNT:KeyPress(player, key)
	if ( player:InVehicle() ) then
		if (key == IN_USE) then
			local vehicle = player:GetVehicle();
			local parentVehicle = vehicle:GetParent();

			if (IsValid(parentVehicle) and parentVehicle.ItemTable) then
				if (!parentVehicle.IsLocked) then
					player:ExitVehicle();
				end;
			end;
		end;
	end;
end;

-- Called when a player uses an entity.
function MOUNT:PlayerUse(player, entity, testing)
	local curTime = CurTime();

	if ( !entity:IsVehicle() ) then
		return;
	end;

	if ( player:InVehicle() ) then
		if (player.nextExitVehicle and player.nextExitVehicle >= curTime) then
			return false;
		else
			local parentVehicle = player:GetVehicle():GetParent();

			if (IsValid(parentVehicle) and parentVehicle.ItemTable) then
				return false;
			else
				return;
			end;
		end;
	end;

	if ( !entity.IsLocked and entity.ItemTable and player:KeyDown(IN_USE) ) then
		local position = player:GetEyeTraceNoCursor().HitPos;
		local validSeat = nil;
		
		if ( entity.Passengers and IsValid( entity:GetDriver() ) ) then
			for k, v in pairs(entity.Passengers) do
				if ( IsValid(v) and v:IsVehicle() and !IsValid( v:GetDriver() ) ) then
					local distance = v:GetPos():Distance(position);
					
					if ( !validSeat or distance < validSeat[1] ) then
						validSeat = {distance, v};
					end;
				end;
			end;
			
			if ( validSeat and IsValid( validSeat[2] ) ) then
				player.nextExitVehicle = curTime + 2;

				validSeat[2]:Fire("unlock", "", 0);
					timer.Simple(FrameTime() * 0.5, function()
						if ( IsValid(player) and IsValid( validSeat[2] ) ) then
							player:EnterVehicle( validSeat[2] );
						end;
					end);
				validSeat[2]:Fire("lock", "", 1);
			end;

			return false;
		end;
	end;

	if (player:GetSharedVar("sh_Tied") != 0) then
		return false;
	end;
end;
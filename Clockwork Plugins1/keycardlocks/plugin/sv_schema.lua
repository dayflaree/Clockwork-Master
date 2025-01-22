local PLUGIN = PLUGIN;

-- A function to load the Keycard locks.
function PLUGIN:LoadKeycardLocks()
	local keycardLocks = Clockwork.kernel:RestoreSchemaData( "plugins/keycardlocks/"..game.GetMap() );
	
	for k, v in pairs(keycardLocks) do
		local entity = ents.FindInSphere(v.doorPosition, 16)[1];
		
		if (IsValid(entity)) then
			local keycardLock = self:ApplyKeycardLock(entity);
			
			if (keycardLock) then
				Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
				
				keycardLock:SetLocalAngles(v.angles);
				keycardLock:SetLocalPos(v.position);
				
				if (!v.locked) then
					keycardLock:Unlock();
				else
					keycardLock:Lock();
				end;
				if (v.level == 5) then
					keycardLock:SetDTInt(0, 5);
				elseif (v.level == 4) then
					keycardLock:SetDTInt(0, 4);
				elseif (v.level == 3) then
					keycardLock:SetDTInt(0, 3);
				elseif (v.level == 2) then
					keycardLock:SetDTInt(0, 2);
				else
					keycardLock:SetDTInt(0, 1);
				end;
			end;
		end;
	end;
end;

-- A function to save the Keycard locks.
function PLUGIN:SaveKeycardLocks()
	local keycardLocks = {};
	
	for k, v in pairs( ents.FindByClass("cw_keycardlock") ) do
		if (IsValid(v.entity)) then
			keycardLocks[#keycardLocks + 1] = {
				key = Clockwork.entity:QueryProperty(v, "key"),
				locked = v:IsLocked(),
				level = v:IsLevel(),
				angles = v:GetLocalAngles(),
				position = v:GetLocalPos(),
				uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
				doorPosition = v.entity:GetPos()
			};
		end;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/keycardlocks/"..game.GetMap(), keycardLocks);
end;

-- A function to apply a Keycard lock.
function PLUGIN:ApplyKeycardLock(entity, position, angles)
	local keycardLock = ents.Create("cw_keycardlock");
	
	keycardLock:SetParent(entity);
	keycardLock:SetDoor(entity);
	
	if (position) then
		if (type(position) == "table") then
			keycardLock:SetLocalPos( Vector(-1.0313, 43.7188, -1.2258) );
			keycardLock:SetPos( keycardLock:GetPos() + (position.HitNormal * 4) );
		else
			keycardLock:SetPos(position);
		end;
	end;
	
	if (angles) then
		keycardLock:SetAngles(angles);
	end;
	
	keycardLock:Spawn();
	
	if (IsValid(keycardLock)) then
		return keycardLock;
	end;
end;

-- A function to bust down a door.
function PLUGIN:BustDownDoor(player, door, force)
	door.bustedDown = true;
	
	door:SetNotSolid(true);
	door:DrawShadow(false);
	door:SetNoDraw(true);
	door:EmitSound("physics/wood/wood_box_impact_hard3.wav");
	door:Fire("Unlock", "", 0);
	
	if (IsValid(door.keycardLock)) then
		door.keycardLock:Explode();
		door.keycardLock:Remove();
	end;
	
	if (IsValid(door.breach)) then
		door.breach:BreachEntity();
	end;
	
	local fakeDoor = ents.Create("prop_physics");
	
	fakeDoor:SetCollisionGroup(COLLISION_GROUP_WORLD);
	fakeDoor:SetAngles( door:GetAngles() );
	fakeDoor:SetModel( door:GetModel() );
	fakeDoor:SetSkin( door:GetSkin() );
	fakeDoor:SetPos( door:GetPos() );
	fakeDoor:Spawn();
	
	local physicsObject = fakeDoor:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		if (!force) then
			if (IsValid(player)) then
				physicsObject:ApplyForceCenter( (door:GetPos() - player:GetPos() ):GetNormal() * 10000 );
			end;
		else
			physicsObject:ApplyForceCenter(force);
		end;
	end;
	
	Clockwork.entity:Decay(fakeDoor, 300);
	
	Clockwork.kernel:CreateTimer("reset_door_"..door:EntIndex(), 300, 1, function()
		if (IsValid(door)) then
			door.bustedDown = nil;
			
			door:SetNotSolid(false);
			door:DrawShadow(true);
			door:SetNoDraw(false);
		end;
	end);
end;
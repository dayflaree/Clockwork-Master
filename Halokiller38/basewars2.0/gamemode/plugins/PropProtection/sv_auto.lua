--=========================
--	Prop Protection/damage
--=========================
local PLUGIN = PLUGIN;
PLUGIN.defaultEntities = {};

-- Called just after the maps entities have been created.
function PLUGIN:InitPostEntity()
	for k,v in ipairs(ents.GetAll()) do
		if (!v:IsPlayer()) then
			table.insert(self.defaultEntities, v);
		end;
	end;
end;

-- Called when a player attempts to spawn a prop.
function PLUGIN:PlayerSpawnProp(ply, model)
	for k,v in ipairs(self.bannedProps) do
		if (string.find(model, v) and !ply:HasFlag("a")) then
			ply:Notify("That prop is banned!");
			
			return false;
		end;
	end;
	
	if (ply:CanAfford(self.propCost)) then
		ply:TakeCash(self.propCost);
	else
		ply:Notify("You cannot afford that!");
		
		return false;
	end;
end;

-- Called when a player attempts to give someone a SWEP.
function PLUGIN:PlayerGiveSWEP(ply, class, weapon)
	return ply:HasFlag("a");
end;

-- Called when a player attempts to spawn an effect.
function PLUGIN:PlayerSpawnEffect(ply, model)
	return ply:HasFlag("a");
end;

-- Called when a player attempts to spawn an NPC.
function PLUGIN:PlayerSpawnNPC(ply, npc, weapon)
	return ply:HasFlag("a");
end;

-- Called when a player attempts to spawn a SENT.
function PLUGIN:PlayerSpawnSENT(ply, class)
	return ply:HasFlag("a");
end;

-- Called when a player attempts to spawn a SWEP.
function PLUGIN:PlayerSpawnSWEP(ply, class, weapon)
	return ply:HasFlag("a");
end;

-- Called when a player attempts to spawn a ragdoll.
function PLUGIN:PlayerSpawnRagdoll(ply, model, entity)
	return ply:HasFlag("a");
end;

-- Called when a player attempts to spawn a vehicle.
function PLUGIN:PlayerSpawnVehicle(ply, model, vehicle, vehicleTable)
	return ply:HasFlag("a");
end;

-- Called when a player has spawned a prop.
function PLUGIN:PlayerSpawnedProp(ply, model, entity)
	if (ValidEntity(entity)) then
		entity.propOwner = ply;
		entity.propHealth = self.propHealth;
	end;
end;

-- Called when a player attempts to use the physgun to pick something up.
function PLUGIN:PhysgunPickup(ply, entity)
	if (table.HasValue(self.defaultEntities, entity)) then return false; end;
	
	if (ply:HasFlag("a")) then
		if (entity:IsPlayer()) then
			if (!entity:InVehicle()) then
				entity:SetMoveType(MOVETYPE_NOCLIP);
			end;
		end;
		
		return true;
	end;
	
	if (!ply:HasPropAccess(entity)) then
		return false;
	end;
	
	if (string.find(entity:GetClass(), "npc_") or string.find(entity:GetClass(), "prop_dynamic")) then
		return false;
	end;
	
	return RP.BaseClass:PhysgunPickup(ply, entity);
end;

-- Called when a player drops something with the physgun.
function PLUGIN:PhysgunDrop(ply, entity)
	if (entity:IsPlayer()) then
		entity:SetMoveType(MOVETYPE_WALK);
	end;
end;

-- Called when the player attempts to use the tool gun.
function PLUGIN:CanTool(ply, trace, tool)
	if (ply:HasFlag("a")) then return true; end;
	local entity = trace.Entity;
	
	if (ValidEntity(entity)) then
		if (tool == "nail") then
			local line = {};
			
			line.start = trace.HitPos;
			line.endpos = trace.HitPos + ply:GetAimVector() * 16;
			line.filter = {ply, entity};
			
			line = util.TraceLine(line);
			
			if (ValidEntity(line.Entity)) then
				if (self.defaultEntities[line.Entity]) then return false; end;
			end;
		end;
		
		-- Check if we're using the remover tool and we're trying to remove constrained entities.
		if (tool == "remover" and ply:KeyDown(IN_ATTACK2) and !ply:KeyDownLast(IN_ATTACK2)) then
			local entities = constraint.GetAllConstrainedEntities(entity);
			
			for k, v in pairs(entities) do
				if (self.defaultEntities[v]) then return false; end;
			end;
		end;
		
		if (self.defaultEntities[entity]) then return false; end;
		
		if (!self:PhysgunPickup(ply, entity)) then return false; end;
	else
		return false;
	end;
	
	return RP.BaseClass:CanTool(ply, trace, tool);
end;

-- Called when an entity takes damage.
function PLUGIN:EntityTakeDamage(entity, inflictor, attacker, amount)
	if (ValidEntity(entity)) then
		if (entity.propHealth) then
			entity.propHealth = math.Clamp(entity.propHealth - amount, 0, self.propHealth);
			
			local control = 255 * math.TimeFraction(0, self.propHealth, entity.propHealth);
			entity:SetColor(control, control, control, 255);
			
			if (entity.propHealth <= 0) then
				entity:Remove();
			end;
		end;
	end;
end;

local playerMeta = FindMetaTable("Player");

-- Returns whether a player can access a prop.
function playerMeta:HasPropAccess(entity)
	if (self:HasFlag("a")) then return true; end;
	
	local owner = entity.propOwner;
	
	if (owner) then
		if (owner == self or owner:InParty(self)) then
			return true;
		end;
	end;
	
	return false;
end;

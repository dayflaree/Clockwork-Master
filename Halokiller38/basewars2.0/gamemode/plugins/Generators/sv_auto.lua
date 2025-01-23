--==============
--	Generators
--==============
resource.AddFile("materials/models/weapons/v_models/blowtortch/blowtortch_textures.vtf");
resource.AddFile("models/weapons/v_blowtortch.mdl");
resource.AddFile("models/weapons/w_blowtortch.mdl");
--==============

local PLUGIN = PLUGIN;
PLUGIN.nextPayDay = 0;

RP.generator.created = {};

-- Creates a new generator.
function RP.generator:Create(ply, _type, pos)
	ply.numGenerators = ply.numGenerators or 0;
	
	local genData = self:Get(_type);
	if (!pos) then
		pos = ply:EyeTrace(100).HitPos;
	end;
	
	if (genData) then
		if (ply.numGenerators < self.max) then
			local ent = ents.Create("rp_generator");
			ent:SetPos(pos);
			ent.generator = {}
			ent.generator.owner = ply;
			ent.generator.type = genData.uniqueID;
			ent.generator.holding = 0;
			ent.generator.energy = genData.startEnergy;
			ent:SetNWString("genType", genData.uniqueID);
			ent:SetNWInt("holdingAmount", 0);
			ent:SetNWInt("genEnergy", genData.startEnergy);
			ent:SetModel(genData.model);
			ent:Spawn();
			
			table.insert(self.created, ent);
			
			ply.numGenerators = ply.numGenerators + 1;
			
			return ent;
		else
			return false, "You have reached the maximum number of generators!";
		end;
	else
		return false, "Invalid generator type.";
	end;
end;

-- Upgrades a generator to the next level.
function RP.generator:Upgrade(entity, level)
	if (!ValidEntity(entity)) then
		return false, "That is not a valid entity!";
	end;
	
	if (!entity.generator) then
		return false, "That is not a valid generator!";
	end;
	
	if (!level) then
		local curType = entity.generator.type;
		
		if (curType == "gen_basic") then
			level = "gen_advanced";
		elseif (curType == "gen_advanced") then
			level = "gen_master";
		else
			return false, "Generator already upgraded to the maximum!";
		end;
	end;
	
	local genData = self:Get(level);
	
	if (genData) then
		entity.generator.type = genData.uniqueID;
		entity.generator.energy = genData.startEnergy;
		
		entity:SetNWString("genType", genData.uniqueID);
		entity:SetNWInt("genEnergy", genData.startEnergy);	
	else
		return false, "Invalid generator type";
	end;
end;

-- Activates the payday for all generators.
function RP.generator:PayDay()
	local generators = self:GetAll();
	
	for k,v in pairs(generators) do
		if (v.generator) then

			local genData = self:Get(v.generator.type);
			
			local jitter = genData.payAmount / 5;
			local addAmount = math.random(genData.payAmount - jitter, genData.payAmount + jitter);
			
			v.generator.holding = v.generator.holding + addAmount;
			
			local energyJitter = genData.energyLoss / 5;
			local energyLoss = math.random(genData.energyLoss - energyJitter, genData.energyLoss + energyJitter);
			
			v.generator.energy = v.generator.energy - energyLoss;

			v:SetNWInt("holdingAmount", v.generator.holding);
			v:SetNWInt("genEnergy", v.generator.energy);
			
			if (v.generator.energy <= 0 or !ValidEntity(v.generator.owner)) then
				self:Destroy(v);
			end;
		end;
	end;
end;

-- Repairs a generator.
function RP.generator:Repair(entity, amount)
	if (table.HasValue(self.created, entity)) then
		local genData = self:Get(entity.generator.type);
		
		entity.generator.energy = math.Clamp(entity.generator.energy + amount, 0, genData.startEnergy);
		entity:SetNWInt("genEnergy", entity.generator.energy);
		
		if (entity.generator.energy <= 0) then
			self:Destroy(entity);
		end;
	end;
end;

-- Destroys a generator.
function RP.generator:Destroy(entity)
	if (table.HasValue(self.created, entity)) then
		entity.generator.owner:Notify("One of your generators has been destroyed!");
		
		-- Add Effect
		local effectData = EffectData();
		effectData:SetStart(entity:GetPos());
		effectData:SetOrigin(entity:GetPos());
		effectData:SetScale(1);
		util.Effect("HelicopterMegaBomb", effectData);
		
		self.created[table.KeyFromValue(self.created, entity)] = nil;
		
		entity:Remove();
	end;
end;

-- Gets all creates generators.
function RP.generator:GetAll()
	return self.created;
end;

-- Gets the cash from a generator.
function RP.generator:GiveCash(ply, entity)
	if (entity.generator) then
		local cash = math.Clamp(math.random(20, 40), 0, entity.generator.holding);
		
		if (cash > 0) then
			ply:GiveCash(cash);
			entity.generator.holding = entity.generator.holding - cash;
			
			entity:SetNWInt("holdingAmount", entity.generator.holding);
		end;
	end;
end;

function PLUGIN:Tick()
	local curTime = CurTime();
	
	if (curTime >= self.nextPayDay) then
		RP.generator:PayDay();
		self.nextPayDay = curTime + RP.generator.interval;
	end;
end;

function PLUGIN:EntityTakeDamage(entity, inflictor, attacker, amount)
	if (entity.generator and attacker:IsPlayer()) then
		entity.generator.energy = entity.generator.energy - amount;
		entity:SetNWInt("genEnergy", entity.generator.energy);

		if (entity.generator.energy <= 0) then
			RP.generator:Destroy(entity);
		end;
	end;
end;

function PLUGIN:EntityRemoved(entity)
	if (entity.generator) then
		local ply = entity.generator.owner;
		
		if (ValidEntity(ply)) then
			ply.numGenerators = ply.numGenerators - 1;
		end;
	end;
end;

function PLUGIN:PlayerDisconnected(ply)
	for k,v in ipairs(ply:GetGenerators()) do
		RP.generator:Destroy(v);
	end;
end;

local playerMeta = FindMetaTable("Player");

function playerMeta:GetGenerators()
	local gens = {};
	for k,v in ipairs(RP.generator:GetAll()) do
		if (v.generator) then
			if (v.generator.owner == self) then
				table.insert(gens, v);
			end;
		end;
	end;
	
	return gens;
end;

-- concommand.Add("/rpspawngenerator", function(ply, cmd, args)
	-- local t = args[1];
	
	-- RP.generator:Create(ply, t, ply:GetEyeTraceNoCursor().HitPos);
-- end);

-- concommand.Add("/rpupgradegenerator", function(ply, cmd, args)
	-- local gen = ply:GetEyeTraceNoCursor().Entity;
	
	-- RP:DataStream(ply, "addUpgradeBar", {gen, 10});
	
	-- timer.Simple(10, function()
		-- local succ, err = RP.generator:Upgrade(gen);
		
		-- if (!succ) then
			-- ply:Notify(err)
		-- end;
	-- end);
-- end);

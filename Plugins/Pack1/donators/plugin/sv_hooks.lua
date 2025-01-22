
local PLUGIN = PLUGIN;

-- Called when a player attempts to use a character.
function PLUGIN:PlayerCanUseCharacter(player, character)
	if (!player.cwDonation and !table.HasValue(self.creatureUsers, player:SteamID())) then
		if (character.faction == FACTION_ZOMBIE or character.faction == FACTION_ANTLION 
			or character.faction == FACTION_ALIENGRUNT or character.faction == FACTION_BIRD) then
			return "You must be an active Gold Member to use this character!";
		end;
	end;
end;


-- Called when a player attempts to say something out-of-character.
function PLUGIN:PlayerCanSayOOC(player, text)
	if (player:GetFaction() == FACTION_ZOMBIE or player:GetFaction() == FACTION_ANTLION) then
		Clockwork.player:Notify(player, "Characters in your faction cannot use out-of-character discussion.");
		return false;
	end;
end;

-- Called when a player attempts to spawn a ragdoll.
function PLUGIN:PlayerSpawnRagdoll(player, model)
	if (!IsValid(player)) then return false; end;
	if (!Clockwork.player:HasFlags(player, "r")) then return false; end;
		
	if (!player:Alive() or player:IsRagdolled()) then
		Clockwork.player:Notify(player, "You cannot do this action at the moment!");
			
		return false;
	end;
end;

function PLUGIN:PlayerGiveWeapons(player)
	if (player:GetFaction() == FACTION_ANTLION) then
		if (Clockwork.class.buffer[player:Team()].name == CLASS_ANTLION_WORKER) then
			Clockwork.player:GiveSpawnWeapon(player, "cw_acidspray");
		end;
	end;
end;

-- Called when a player's death sound should be played.
function PLUGIN:PlayerPlayDeathSound(player, gender)
	local playerFaction = player:GetFaction()
	local playerModel = player:GetModel()

	if (playerFaction == FACTION_ANTLION) then
		return "npc/antlion/distract1.wav";
	elseif (playerFaction == FACTION_ALIENGRUNT) then
		return "npc/aliengrunt/die.wav";

	-- Birds.
	elseif (playerFaction == FACTION_BIRD) then

		-- Crow death sounds.
		if (playerModel == "models/crow.mdl" or player:GetModel() == "models/pigeon.mdl") then
			return "npc/crow/pain2.wav";

		-- Seagull death sounds.
		elseif (player:GetModel() == "models/seagull.mdl") then
			return "ambient/creatures/seagull_pain3.wav";
		end;

	-- Zombie faction
	elseif (playerFaction == FACTION_ZOMBIE) then

		-- Zombine.
		if (playerModel == "models/zombie/zombie_soldier.mdl") then
			return "npc/zombine/zombine_die"..math.random(1, 2)..".wav";

		-- Poison Zombie.
		elseif (playerModel == "models/zombie/poison.mdl") then
			return "npc/zombie_poison/pz_die"..math.random(1, 2)..".wav";

		-- Fast zombies and normal zombies have the same death sounds.
		else
			return "npc/zombie/zombie_die"..math.random(1, 3)..".wav";
		end;
	end;
end;

-- Called when a player's pain sound should be played.
function PLUGIN:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	local faction = player:GetFaction();
	
	if (faction == FACTION_ANTLION) then
		return "npc/antlion/pain"..math.random(1, 2)..".wav";		
	elseif (faction == FACTION_ALIENGRUNT)	then
	    return "npc/aliengrunt/pain"..math.random(1, 3)..".wav";		    
	elseif (faction == FACTION_BIRD) then
		local model = player:GetModel();
		if(model == "models/crow.mdl") then
			return "npc/crow/pain"..math.random(1, 2)..".wav";
		elseif (model == "models/pigeon.mdl") then
			return "ambient/creatures/pigeon_idle3.wav";
		elseif (model == "models/seagull.mdl") then
			return "ambient/creatures/seagull_pain"..math.random(1, 2)..".wav"
		end;
	elseif (faction == FACTION_ZOMBIE) then
		-- Zombine.
		if (playerModel == "models/zombie/zombie_soldier.mdl") then
			return "npc/zombine/zombine_pain"..math.random(1, 4)..".wav";
		-- Poison Zombie.
		elseif (playerModel == "models/zombie/poison.mdl") then
			return "npc/zombie_poison/pz_die"..math.random(1, 2)..".wav";
		-- Fast zombies and normal zombies have the same death sounds.
		else
			return "npc/zombie/zombie_pain"..math.random(1, 6)..".wav";
		end;
	end;
end;

-- Called when a player's footstep sound should be played.
function PLUGIN:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	local playerFaction = player:GetFaction();
	local playerModel = player:GetModel();
	local playerClass = player:GetClass();
	
	if (playerFaction == FACTION_ANTLION) then
		if (playerModel == "models/AntLion.mdl" or playerModel == "models/antlion_worker.mdl") then
			player:EmitSound("npc/antlion/foot"..math.random(1, 4)..".wav", 25);
		elseif (playerModel == "models/antlion_guard.mdl") then
			player:EmitSound("npc/antlion_guard/foot_heavy"..math.random(1, 2)..".wav", 150);
		end;
	elseif (playerFaction == FACTION_ALIENGRUNT) then	
	    player:EmitSound("npc/antlion_guard/foot_light"..math.random(1, 2)..".wav", 75);

	-- Zombies		
	elseif (playerFaction == FACTION_ZOMBIE) then

		-- Fast zombie
		if (playerModel == "models/zombie/fast.mdl" or playerModel == "models/zombie/fast_torso.mdl") then
			player:EmitSound("npc/fast_zombie/foot"..math.random(1, 4)..".wav")

		-- Zombine
		elseif (playerModel == "models/zombie/zombie_soldier.mdl") then
			player:EmitSound("npc/zombine/gear"..math.random(1, 3)..".wav", 100)

		-- Headcrabs
		elseif (string.find(playerModel, "headcrab")) then
			player:EmitSound("npc/headcrab_poison/ph_step"..math.random(1, 4)..".wav", 40)

		-- Assume default steps otherwise
		else 
			player:EmitSound("npc/zombie/foot"..math.random(1, 3)..".wav", 75);
		end;

	elseif (playerFaction == FACTION_BIRD) then
		player:EmitSound("npc/crow/hop2.wav", 25);
	else
		return;
	end;
	
	-- If passed at least one of the above; Don't play default footstep.
	-- return true; ((seems to break ALL footsteps, disabling for now))
end;

-- Called when an entity takes damage.
function PLUGIN:EntityTakeDamage(entity, damageInfo)
	local player = Clockwork.entity:GetPlayer(entity);
	
	if (player) then
		if (player:GetFaction() == FACTION_ANTLION and damageInfo:IsDamageType(DMG_FALL)) then
			damageInfo:ScaleDamage(0);
			player:EmitSound("npc/antlion/land1.wav");
		elseif (player:GetFaction() == FACTION_BIRD and damageInfo:IsDamageType(DMG_FALL)) then
			damageInfo:ScaleDamage(0);
			player:EmitSound("npc/crow/hop1.wav");
		end;
	end;
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local faction = player:GetFaction();
	local model = player:GetModel();
	
	local flySound = nil;
	local randomChatterList = nil;
	
	if (faction == FACTION_ANTLION) then
		flySound = "npc/antlion/fly1.wav";
		randomChatterList = self.antlionIdleSounds;
		infoTable.jumpPower = Clockwork.config:Get("jump_power"):Get() * 4;
		infoTable.runSpeed = Clockwork.config:Get("run_speed"):Get() * 1.75;
	
	-- Set info for zombie characters with model of:
	elseif (faction == FACTION_ZOMBIE) then

		-- Fast Zombies
		if (model == "models/zombie/fast.mdl" or model == "models/zombie/fast_torso.mdl") then
			infoTable.runSpeed = Clockwork.config:Get("run_speed"):Get() * 2;
			infoTable.jumpPower = Clockwork.config:Get("jump_power"):Get() * 2;
			randomChatterList = self.fastIdleSounds;
			
		-- Classic Zombies
		elseif (model == "models/zombie/classic.mdl" or model == "models/zombie/classic_torso.mdl") then
			infoTable.runSpeed = Clockwork.config:Get("run_speed"):Get() * 0;
			infoTable.walkSpeed = Clockwork.config:Get("walk_speed"):Get() * 0.35;
			randomChatterList = self.zombieIdleSounds;
			
		-- Poison Zombies
		elseif (model == "models/zombie/poison.mdl") then
			infoTable.runSpeed = 0;
			infoTable.walkSpeed = Clockwork.config:Get("walk_speed"):Get() * 0.4;
			randomChatterList = self.poisonIdleSounds;
			
		-- Zombines
		elseif (model == "models/zombie/zombie_soldier.mdl") then
			infoTable.walkSpeed = Clockwork.config:Get("walk_speed"):Get() * 0.35;
			randomChatterList = self.zombineIdleSounds;			

		-- Classic Headcrabs
		elseif (model == "models/headcrabclassic.mdl" or model == "models/lamarr.mdl") then
			infoTable.runSpeed = 0;
			infoTable.walkSpeed = Clockwork.config:Get("walk_speed"):Get() * 0.75;
			infoTable.jumpPower = Clockwork.config:Get("jump_power"):Get() * 1.25;
			randomChatterList = self.headcrabIdleSounds;
			
		-- Fast Headcrabs
		elseif (model == "models/headcrab.mdl") then
			infoTable.runSpeed = Clockwork.config:Get("run_speed"):Get() * 1.5;
			infoTable.jumpPower = Clockwork.config:Get("jump_power"):Get() * 1.5;
			randomChatterList = self.fastcrabIdleSounds;
			
		-- Poison Headcrabs
		elseif (model == "models/headcrabblack.mdl") then
			infoTable.runSpeed = 0;
			infoTable.walkSpeed = Clockwork.config:Get("walk_speed"):Get() * 0.2;
			randomChatterList = self.poisoncrabIdleSounds;
		end;

	elseif (faction == FACTION_BIRD) then
		flySound = "npc/crow/flap2.wav";
		
		if (model == "models/crow.mdl") then
			randomChatterList = self.crowIdleSounds;
		elseif (model == "models/seagull.mdl") then
			randomChatterList = self.seagullIdleSounds;
		elseif (model == "models/pigeon.mdl") then
			randomChatterList = self.pigeonIdleSounds;
		end;

	--If in none of those factions, return.
	else 
		return;
	end;
	
	--Handle random chatter.
	if (!self.cwNextChatterEmit) then
		self.cwNextChatterEmit = curTime + math.random(5, 15);

	elseif (curTime >= self.cwNextChatterEmit and randomChatterList) then
		self.cwNextChatterEmit = nil;
		
		player:EmitSound(randomChatterList[ math.random(1, #randomChatterList) ], 100);
	end;
	
	--Fly sound - if in air and sound exists, play.
	if (flySound and !player:IsOnGround() and player:Alive() and player:GetMoveType() == MOVETYPE_WALK) then
		--Check if sound already exists, to not recreate it again - since it loops.
		if (!player.cwFlySound) then
			player.cwFlySound = CreateSound(player, flySound);
			player.cwFlySound:Play();
		end;
	elseif (player.cwFlySound) then
		player.cwFlySound:Stop();
		player.cwFlySound = nil;
	end;
end;

-- Called when a player's character creation info should be adjusted.
function PLUGIN:PlayerAdjustCharacterCreationInfo(player, info, data)

	if (data.faction and (data.faction == FACTION_ANTLION or data.faction == FACTION_ZOMBIE)) then
		for k, v in pairs(data.attributes) do
			local attributeTable = Clockwork.attribute:FindByID(k);
			
			if (attributeTable and attributeTable.isOnCharScreen) then
				local uniqueID = attributeTable.uniqueID;
				local maximum = attributeTable.maximum;
				
				info.attributes[uniqueID].amount = maximum;
			end;
		end;
	end;
end;

function PLUGIN:PlayerShouldGainHunger(player)
	if (player:GetFaction() == FACTION_ZOMBIE or player:GetFaction() == FACTION_ANTLION or player:GetFaction() == FACTION_ALIENGRUNT) then
		return false;
	end;
end;

function PLUGIN:PlayerShouldGainThirst(player)
	if (player:GetFaction() == FACTION_ZOMBIE or player:GetFaction() == FACTION_ANTLION or player:GetFaction() == FACTION_ALIENGRUNT) then
		return false;
	end;
end;

function PLUGIN:PlayerDeath(player)
	if (player:GetFaction() == FACTION_ANTLION) then
		local chance = math.random(0, 100);

		if (chance >= 75) then
			local pos = player:WorldSpaceCenter();
			local itemTable = Clockwork.item:CreateInstance("antlion_meat_raw");

			if (itemTable) then
				Clockwork.entity:CreateItem(nil, itemTable, pos);
			end;
		end;
	end;
end;
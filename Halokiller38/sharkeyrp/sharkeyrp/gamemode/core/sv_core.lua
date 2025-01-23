//Called when the GM Starts
function RP:Initialize()
	self.MySQL:Connect();
	self:InitCore();
	timer.Simple(5, self.SavePlayerData, self);
	timer.Simple(2, self.SavePlayerAmmo, self);
end;

//Called when all player's data should be saved
function RP:SavePlayerData()
	for _, v in pairs(_player.GetAll()) do
		v:SetAmmoData();
		v:SaveData();
	end;
	
	timer.Simple(5, self.SavePlayerData, self);
end;

function RP:SavePlayerAmmo()
	for _, v in pairs(_player.GetAll()) do
		for _, weapon in pairs(v:GetWeapons()) do
			local itemTable = self.item:GetWeapon(weapon);
			if (itemTable) then
				self.item:DataID(itemTable.itemID, {Clip = weapon:Clip1()});
			end;
		end;
	end;
	timer.Simple(2, self.SavePlayerAmmo, self);
end;

//Called when a player first spawns
function RP:PlayerInitialSpawn(player)
	player:LoadData();
end;

//Called when a player spawns
function RP:PlayerSpawn(player)
	if ( IsValid(player) ) then
		player:ShouldDropWeapon(false);
		
		local job = RP.job:GetJob(player);
		if (!job) then
			job = RP.job:Get("citizen");
		end;
		player:SetModel(table.Random(job.models));
		self:PlayerLoadout(player);

		if ( player:FlashlightIsOn() ) then
			player:Flashlight(false);
		end;
		player:SetCollisionGroup(COLLISION_GROUP_PLAYER);
		player:SetMaxHealth(100);
		player:SetMaterial("");
		player:SetMoveType(MOVETYPE_WALK);
		player:Extinguish();
		player:UnSpectate();
		player:GodDisable();
		player:ConCommand("-duck");
		player:SetColor(255, 255, 255, 255);

		player:SetCrouchedWalkSpeed( 75 );
		player:SetWalkSpeed( 225 );
		player:SetJumpPower( 175 );
		player:SetRunSpeed( 300 );
		player:UnLock();
	else
		player:KillSilent();
	end;
end;

//Called when a player presses F1
function RP:ShowHelp(player)
	RP:DataStream(player, "ToggleMenu", {});
end;

//Called when a player dies
function RP:PlayerDeath(player, weapon, attacker)
	player:SetDSP(114);
	player.NextSpawn = CurTime() + 10;
	RP:DataStream(player, "NetworkDeath", {NextSpawn = player.NextSpawn});
end;

//Called when a player dies
function RP:DoPlayerDeath(player, attacker, damageInfo)
	player:SendLua("RunConsoleCommand(\"play\", \"player/heartbeat1.wav\");");
	player:CreateRagdoll();
	player:AddDeaths(1);
	if (player.primaryWeapon) then
		player:UnloadItem(player.primaryWeapon);
	end;
	if (player.secondaryWeapon) then
		player:UnloadItem(player.secondaryWeapon);
	end;
	player:EmitSound("ambient/voices/m_scream1.wav");
end;

//Called every think whilst a player is dead
function RP:PlayerDeathThink(player)
	if (CurTime() >= player.NextSpawn) then
		player:Spawn();
		player.NextSpawn = math.huge;
	end;
end;
	
//Called when a player is loaded out
function RP:PlayerLoadout(player)
	player:SetDSP(1);
	player:SendLua("RunConsoleCommand(\"stopsounds\");");
	player:EmitSound("ambient/levels/canals/drip3.wav");
	player:Give("weapon_physgun");
	player:Give("weapon_physcannon");
	player:Give("gmod_tool");
	
	return false;
end;

//Called when a player death sound should be played
function RP:PlayerDeathSound()
	return true;
end;

// Called when a players data is loaded
function RP:PlayerLoaded(player)
	player:SetAmmoTable(player:GetAmmoData())
end;

//Called when a player says something in the chatbox
function RP:PlayerSay(player, text, team)
	if (RP.command) then
		if (RP.command:ParseSayText(player, text)) then
			return "";
		end;
	end;
	
	if (RP.chat) then
		RP.chat:ParseSayText(player, text, team);
	end;
	
	return "";
end;

//Makes entities flush to the ground (lol conna)
function RP:MakeFlushToGround(entity, position, normal)
	entity:SetPos(position + (entity:GetPos() - entity:NearestPoint(position - (normal * 512))));
end;

/* Weapon Hooks */


local meta = FindMetaTable( "Player" );

function meta:Initialize()

	self:SetTeam( 1 ); 

	--Setup variables
	for k, v in pairs( TS.ServerVariables ) do
	
		if( type( TS.ServerVariables[k] ) == "table" ) then
		
			self[k] = { }
			
		else
		
			self[k] = v;
			
		end
	
	end
	
	self:Observe( false );
	self:SetupStatProgress();
	
	self:SetPlayerBleeding( false );
	self:SetPlayerCanSprint( true );
	self:SetPlayerConscious( true );
	
	self:Lock();
	self:CallEvent( "HorseyMapViewOn" );

	timer.Simple( .2, self.MakeInvisible, self, true );
	timer.Simple( .3, self.CrosshairDisable, self );
	timer.Simple( .4, self.DrawViewModel, self, false );
	
	--Delay so that it doesn't fuck up
	timer.Simple( .6, self.HandlePlayer, self );
	
	TS.WriteLog( "connects", self:Name() .. " [" .. self:SteamID() .. "][" .. self:IPAddress() .. "] joined the game at " .. tostring( os.date() ) );

end

function meta:RefreshChar()
	
	--Inventories
	self.Inventories = { }
	
	--Just a list of the items in our inventory
	self.InventoryList = { }
	
	--Serverside inventory grid.  CPU lag?  We'll see.
	self.InventoryGrid = { }
	
	for n = 1, TS.MaxInventories do
		
		self.Inventories[n] = { }
		self.Inventories[n].Name = "";
		self.Inventories[n].Width = 9;
		self.Inventories[n].Height = 6;
	
		self.InventoryGrid[n] = { }
	
		for x = 0, 8 do
		
			self.InventoryGrid[n][x] = { }
		
			for y = 0, 5 do
			
				self.InventoryGrid[n][x][y] = { }
				self.InventoryGrid[n][x][y].Filled = false;
			
			end
			
		end
		
	end
	
	self:CallEvent( "ResetInventory" );
	
	self:MakeInvisible( true );

	self:SetTeam( 1 );
	self:Lock();
	
	self.Frequency = 0;
	self.CombineFlags = "";
	self.PlayerFlags = "";
	self.Away = nil;
	self.LastTitleUpdate = CurTime()
	
	--Reset stats
	self:SetPlayerStrength( 10 );
	self:SetPlayerSpeed( 10 );
	self:SetPlayerEndurance( 10 );
	self:SetPlayerAim( 10 );
	
	self:SetupStatProgress();
	
	if( self.BackEntity and self.BackEntity:IsValid() ) then
		self.BackEntity:Remove();
	end

end

function meta:CharacterInitialize()
	
	--Inventories
	self.Inventories = { }
	
	--Just a list of the items in our inventory
	self.InventoryList = { }
	
	--Serverside inventory grid.  CPU lag?  We'll see.
	self.InventoryGrid = { }
	
	for n = 1, TS.MaxInventories do
		
		self.Inventories[n] = { }
		self.Inventories[n].Name = "";
		self.Inventories[n].Width = 9;
		self.Inventories[n].Height = 6;
	
		self.InventoryGrid[n] = { }
	
		for x = 0, 8 do
		
			self.InventoryGrid[n][x] = { }
		
			for y = 0, 5 do
			
				self.InventoryGrid[n][x][y] = { }
				self.InventoryGrid[n][x][y].Filled = false;
			
			end
			
		end
		
	end
	
	self:CallEvent( "ResetInventory" );

	self:SetHealth( 100 );
	self.MaxHealth = 100;
	
	self.StatusIsInjured = false;
	self.StatusIsCrippled = false;
	self.IsTied = false;
	
	self.LastDrunkMulUpdate = 0;
	self.LastDrunkWalkUpdate = 0;
	self.LastDrunkWalkMul = 0;
	
	self.Frequency = 0;
	self.CombineFlags = "";
	self.PlayerFlags = "";
	
	self:Conscious();
	
	--Compute player speeds on new character
	self:ComputePlayerSpeeds();
	
	self:SetPlayerSprint( 100 );
	self:SetPlayerConsciousness( 100 );
	self:SetPlayerTitle( "" );
	self:SetPlayerTitle2( "" );
	self:SetPlayerBleeding( false );
	self:SetPlayerCanSprint( true );
	self:SetPlayerConscious( true );
	
	self:ResetBleeding();
	self:MakeNotInvisible();
	self:SetupStatProgress();
	
	self:SetTeam( 1 );
	
	--We're initialized and allow the player to move around again
	self.Initialized = true;
	self:UnLock();
	
	self:DrawViewModel( true );
	
	self:CallEvent( "HorseyMapViewOff" );
	
	local ID = self:GetSQLData( "uid" );

	local query = "SELECT `userID` FROM `tb_characters` WHERE `userID` = '" .. ID .. "' AND `charName` = '"..TS.Escape(self:GetRPName()).."'";
	TS.AsyncQuery(query, function(q)
		local results = q:getData()
		local saves = #results
		if saves > 0 then
			self:CharLoad(self:GetRPName())
		else
			self:CharSave();
		end

		--Set model
		self:SetModel( self.CitizenModel or "" );
		
		-- Change team, depending on the faction
		if self:CanBeCCA() then
			self:SetTeam(2);
		elseif self:HasCombineFlag("O") then -- OW
			self:SetTeam(3)		
		elseif self:HasCombineFlag("A") then -- CA
			self:SetTeam(4)
		elseif self:HasPlayerFlag("V") then -- Vort
			self:SetTeam(5)
		end
		
		self:KillSilent();
		self:Spawn();
	end)
end

function GM:PlayerSpawn( ply )	
	if( not ply.Initialized ) then
		ply:SetModel( "models/odessa.mdl" );
		return;
	end
	
	if( ply.RagdollEntity and ply.RagdollEntity:IsValid() ) then
		if( ply.BypassUnconscious ) then
			ply:RemoveRagdoll();
			ply.BypassUnconscious = false;
		else
			ply:MakeInvisible();
			ply:CrosshairDisable();
			ply:SetPos( ply.RagdollEntity:GetPos() );
			ply:Freeze( true );
			return;
		end
	end
	
	if( ply:HasInventory( "Backpack" ) ) then
	
		ply.BackEntity = ply:AttachProp( "models/fallout 3/backpack_2.mdl", "chest" );	
		
	end
	
	if( ply:IsHorseysChef() ) then

		ply.HeadEntity = ply:AttachProp( "models/chefHat.mdl", "head" );
		
	end

	ply:SetPlayerDrunkMul( 0 );
	ply:CallEvent( "NoDrunk" );
	ply:MakeNormal();
	
	ply.IsTied = false;
	
	ply:Flashlight( false );

	ply:CrosshairDisable();
	
	ply.LastWeapon = nil;
	
	ply:ResetBodyDamage();
	ply:ResetBleeding();
	
	ply:HandleTeamSpawn();

	ply:SetPlayerSprint( 100 );
	ply:SetPlayerConsciousness( 100 );
	
	if( ply:HasTT() ) then
		ply:Give( "gmod_tool" );
	end
	
	ply:Give( "weapon_physcannon" );
	
	if( not ply:IsPhysBanned() ) then
		ply:Give( "weapon_physgun" );
	end
	
	ply:Give( "ts2_hands" );
	ply:Give( "ts2_keys" );
	
	ply:SelectWeapon( "ts2_hands" );
	
	ply:ComputePlayerSpeeds();
end

function GM:PlayerDeathSound()
	
	return true;

end

function GM:CanPlayerSuicide( ply )

	if( ply:IsTied() or not ply:GetPlayerConscious() ) then
	
		return false;
	
	end
	
	return true;

end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	local makeragdoll = true;

	ply.ForceDeath = false;

	if( not ply.BypassUnconscious ) then

		if( not ply:GetPlayerConscious() ) then
			ply:TakeAllInventoryWeapons();
			ply:Freeze( false );
			return;
		end
		
	elseif( not ply:GetPlayerConscious() ) then

		ply:Conscious();
		makeragdoll = false;
		
	end

	for k, v in pairs( ply.ProcessBars ) do
	
		if( v ~= "spawnload" ) then
	
			ply.ProcessBars[k] = nil;
			
		end
	
	end
	
	umsg.Start( "RAPB", ply ); umsg.End();
	umsg.Start( "TV", ply ); umsg.End();

	ply.HasTempWeapon = false;
	
	local weapon = attacker:GetActiveWeapon().PrintName or attack:GetActiveWeapon():GetClass();
	
	if attacker and attacker != ply then
		TS.PrintMessageAll(2, attacker:GetRPName() .. " (" .. attacker:Nick() .. ") killed " .. ply:GetRPName() .. " (" .. ply:Nick() .. ") with " .. weapon .. ".");
	else
		TS.PrintMessageAll(2, ply:GetRPName() .. " (" .. ply:Nick() .. ") suicided.")
	end
	
	if( ply:GetActiveWeapon():IsValid() ) then
	
		local class = ply:GetActiveWeapon():GetClass();
		
		if( string.find( class, "ts2_" ) and
			class ~= "ts2_base" and
			class ~= "ts2_hands" and
			class ~= "gmod_tool" and
			class ~= "ts2_kanyewest" ) then
			
			TS.CreateItemProp( class, ply:GetActiveWeapon():GetPos(), ply:GetActiveWeapon():GetAngles() );
			
		end
	
	end
	
	if( ply.BackEntity and ply.BackEntity:IsValid() ) then
		ply.BackEntity:Remove();
	end
	
	if( ply.HeadEntity and ply.HeadEntity:IsValid() ) then
		ply.HeadEntity:Remove();
	end
	
	if ply:IsCP() then
		ply:CPDeathDis();
	end
	
	ply:TakeAllInventoryWeapons();

	ply:SnapOutOfStance();
	
	ply.HelmetHealth = 0;
	ply.BodyArmorHealth = 0;
	
	ply:SetAimAnim( false );
	
	if( makeragdoll ) then
		ply:CreateRagdoll();
	end
	
end

function GM:PlayerConnect( name, address )

	TS.PrintMessageAll( 2, name .. " has connected to the server" );
	return true;
end
 
function GM:PlayerDisconnected( ply )

	if( ply:IsCP() ) then
	
		ply:TakeAllInventoryWeapons();
		
	end

	if( ply.RagdollEntity and ply.RagdollEntity:IsValid() ) then
		ply.RagdollEntity:Remove();
	end
	
	if( ply.Initialized ) then
		ply:CharSave();
	end

	TS.PrintMessageAll( 2, ply:GetRPName() .. " [" .. ply:Nick() .. "][" .. ply:SteamID() .. "] has left the server" );
	return true;
	
end

function GM:PlayerTraceAttack()

	return false;

end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )
	
	if( dmginfo:GetAttacker():IsValid() and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():GetActiveWeapon():IsValid() ) then
		
		if( CurTime() - dmginfo:GetAttacker().LastAimProgress > 2 ) then
	
			if( math.random( 1, 2 ) == 2 ) then
				
				dmginfo:GetAttacker():RaiseAimProgress( 1 );
				
			end
			
			dmginfo:GetAttacker().LastAimProgress = CurTime();
			
		end
		
	end
	
	dmginfo:SetDamage(dmginfo:GetDamage()*3);
	
	return dmginfo;
	
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if( not ply.Initialized ) then return; end

	if( dmginfo:IsFallDamage() and ply:Team() == 3 ) then return; end
	
	if( not dmginfo:GetAttacker():IsPlayer() and not dmginfo:GetAttacker():IsNPC() ) then
		return;
	end
	
	if( ply.ObserveMode ) then
		dmginfo:SetDamage( -1000 );
		return dmginfo;
	end

	ply:SnapOutOfStance();
	
	local weapon = dmginfo:GetInflictor();
	
	if( weapon:IsPlayer() or weapon:IsNPC() ) then
		weapon = weapon:GetActiveWeapon();
	end

	if( weapon:IsValid() and weapon:IsWeapon() ) then
	
		return ply:ScaleDamageFromAttack( dmginfo:GetInflictor(), weapon, hitgroup, dmginfo );
	
	end	
	
	return dmginfo;
	
end

function GM:PlayerSwitchFlashlight( ply )

	if( CurTime() - ply.LastFlashSwitch < 1 ) then
		return false;
	end

	ply.LastFlashSwitch = CurTime();

	return ply:HasItem( "flashlight" );

end

function GM:Move( ply, mv )

	if( ply.InStanceAction ) then
	
		return true;
	
	end

end

function GM:PlayerSpray( ply )

	-- this actually means no
	return true;

end

function GM:PlayerShouldTakeDamage( victim, attacker )

	if( attacker:IsProp() ) then
	
		return false;
	
	end
	
	return true;
	
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )

	if( not ply.InCloak ) then
	
		return true;
		
	end
	
	return false;

end

function GM:PlayerCanPickupWeapon( ply, ent )

	if( ent:IsValid() ) then
	
		local class = ent:GetClass();
	
		if( TS.ItemsData[class] or
			class == "weapon_physgun" or
			class == "gmod_tool" or
			class == "weapon_physcannon" ) then
		
			return true;
			
		end
		
		return false;
		
	end

end


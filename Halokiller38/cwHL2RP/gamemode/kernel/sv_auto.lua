/*
	SV HL2RP Shit
*/

-- A function to check if a player is Combine.
function Clockwork.schema:PlayerIsCombine(player, bHuman)
	if ( IsValid(player) and player:GetCharacter() ) then
		local faction = player:QueryCharacter("faction");
		
		if ( self:IsCombineFaction(faction) ) then
			if (bHuman) then
				if (faction == FACTION_MPF) then
					return true;
				end;
			elseif (bHuman == false) then
				if (faction == FACTION_MPF) then
					return false;
				else
					return true;
				end;
			else
				return true;
			end;
		end;
	end;
end;

-- A function to say a message as a dispatch.
function Clockwork.schema:SayDispatch(player, text)
	Clockwork.chatBox:Add(nil, player, "dispatch", text);
end;


-- A function to say a message as a request.
function Clockwork.schema:SayRequest(player, text)
	local isCitizen = (player:QueryCharacter("faction") == FACTION_CITIZEN);
	local listeners = { request = {}, eavesdrop = {} };
	
	for k, v in ipairs( _player.GetAll() ) do
		if ( v:HasInitialized() ) then
			if (v:QueryCharacter("faction") == FACTION_CITIZEN and isCitizen and player != v) then
				if ( v:GetShootPos():Distance( player:GetShootPos() ) <= Clockwork.config:Get("talk_radius"):Get() ) then
					listeners.eavesdrop[v] = v;
				end;
			else
				local isCityAdmin = (v:QueryCharacter("faction") == FACTION_CITYADMIN);
				local isCombine = self:PlayerIsCombine(v);
				
				if (v:HasItemByID("request_device") or isCombine or isCityAdmin) then
					listeners.request[v] = v;
				end;
			end;
		end;
	end;
	local info = Clockwork.chatBox:Add(listeners.request, player, "request", text);
	
	if ( info and IsValid(info.speaker) ) then
		Clockwork.chatBox:Add(listeners.eavesdrop, info.speaker, "request_eavesdrop", info.text);
	end;
end;


-- Called when a player stuns an entity.
function Clockwork.schema:PlayerStunEntity(player, entity)
	local target = Clockwork.entity:GetPlayer(entity);
	
	player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	
	if ( target and target:Alive() ) then
		local curTime = CurTime();
		
		if ( target.nextStunInfo and curTime <= target.nextStunInfo[2] ) then
			target.nextStunInfo[1] = target.nextStunInfo[1] + 1;
			target.nextStunInfo[2] = curTime + 2;
			
			if (target.nextStunInfo[1] == 3) then
				Clockwork.player:SetRagdollState( target, RAGDOLL_KNOCKEDOUT, 45 );
			end;
		else
			target.nextStunInfo = {0, curTime + 2};
		end;
		
		target:ViewPunch( Angle(12, 0, 0) );
		
		umsg.Start("cwStunned", target);
			umsg.Float(2);
		umsg.End();
	end;
end;

-- Called to check if a player does recognise another player.
function Clockwork.schema:PlayerDoesRecognisePlayer(player, target, status, isAccurate, realValue)
	if (self:PlayerIsCombine(target) or target:QueryCharacter("faction") == FACTION_CITYADMIN) then
		return true;
	end;
end;


-- Called when a player's typing display has started.
function Clockwork.schema:PlayerStartTypingDisplay(player, code)
	if (self:PlayerIsCombine(player)) then
		if (code == "n" or code == "y" or code == "w" or code == "r") then
			if (!player.typingBeep) then
				player.typingBeep = true;
				
				player:EmitSound("npc/overwatch/radiovoice/on1.wav");
			end;
		end;
	end;
end;

-- Called when a player's typing display has finished.
function Clockwork.schema:PlayerFinishTypingDisplay(player, textTyped)
	if (self:PlayerIsCombine(player) and textTyped) then
		if (player.typingBeep) then
			player:EmitSound("npc/overwatch/radiovoice/off4.wav");
		end;
	end;
	
	player.typingBeep = nil;
end;

-- A function to apply a Combine lock.
function Clockwork.schema:ApplyCombineLock(entity, position, angles)
	local combineLock = ents.Create("cw_combinelock");
	
	combineLock:SetParent(entity);
	combineLock:SetDoor(entity);
	
	if (position) then
		if (type(position) == "table") then
			combineLock:SetLocalPos( Vector(-1.0313, 43.7188, -1.2258) );
			combineLock:SetPos( combineLock:GetPos() + (position.HitNormal * 4) );
		else
			combineLock:SetPos(position);
		end;
	end;
	
	if (angles) then
		combineLock:SetAngles(angles);
	end;
	
	combineLock:Spawn();
	
	if ( IsValid(combineLock) ) then
		return combineLock;
	end;
end;


-- Called when a player's character has unloaded.
function Clockwork.schema:PlayerCharacterUnloaded(player)
	self:ResetPlayerScanner(player);
end;



-- A function to make a player a scanner.
function Clockwork.schema:MakePlayerScanner(player, noMessage, lightSpawn)
	self:ResetPlayerScanner(player, noMessage);
	
	local scannerClass = "npc_cscanner";
	
	if ( self:IsPlayerCombineRank(player, "SYNTH") ) then
		scannerClass = "npc_clawscanner";
	end;
	
	local position = player:GetShootPos();
	local uniqueID = player:UniqueID();
	local scanner = ents.Create(scannerClass);
	local marker = ents.Create("path_corner");
	
	Clockwork.entity:SetPlayer(scanner, player);
	
	scanner:SetPos( position + Vector(0, 0, 16) );
	scanner:SetAngles( player:GetAimVector():Angle() );
	scanner:SetKeyValue("targetname", "scanner_"..uniqueID);
	scanner:SetKeyValue("spawnflags", 8592);
	scanner:SetKeyValue("renderfx", 0);
	scanner:Spawn(); scanner:Activate();
	
	marker:SetKeyValue("targetname", "marker_"..uniqueID);
	marker:SetPos(position);
	marker:Spawn(); marker:Activate();
	
	if (!lightSpawn) then
		player:Flashlight(false);
		player:RunCommand("-duck");
		
		if (scannerClass == "npc_clawscanner") then
			player:SetHealth(200);
		end;
	end;
	
	player:SetArmor(0);
	player:Spectate(OBS_MODE_CHASE);
	player:StripWeapons();
	player:SetSharedVar("scanner", scanner);
	player:SetMoveType(MOVETYPE_OBSERVER);
	player:SpectateEntity(scanner);
	
	scanner:SetMaxHealth( player:GetMaxHealth() );
	scanner:SetHealth( player:Health() );
	scanner:Fire("SetDistanceOverride", 64, 0);
	scanner:Fire("SetFollowTarget", "marker_"..uniqueID, 0);
	
	self.scanners[player] = {scanner, marker};
	
	Clockwork:CreateTimer("scanner_sound_"..uniqueID, 0.01, 1, function()
		if ( IsValid(scanner) ) then
			scanner.flyLoop = CreateSound(scanner, "npc/scanner/cbot_fly_loop.wav");
			scanner.flyLoop:Play();
		end;
	end);
	
	scanner:CallOnRemove("Scanner Sound", function(scanner)
		if (scanner.flyLoop) then
			scanner.flyLoop:Stop();
		end;
	end);
end;

-- Called when a player attempts to lock an entity.
function Clockwork.schema:PlayerCanLockEntity(player, entity)
	if ( Clockwork.entity:IsDoor(entity) and IsValid(entity.combineLock) ) then
		if ( Clockwork.config:Get("combine_lock_overrides"):Get() or entity.combineLock:IsLocked() ) then
			return false;
		end;
	end;
end;

-- Called when a player attempts to unlock an entity.
function Clockwork.schema:PlayerCanUnlockEntity(player, entity)
	if ( Clockwork.entity:IsDoor(entity) and IsValid(entity.combineLock) ) then
		if ( Clockwork.config:Get("combine_lock_overrides"):Get() or entity.combineLock:IsLocked() ) then
			return false;
		end;
	end;
end;


-- A function to reset a player's scanner.
function Clockwork.schema:ResetPlayerScanner(player, noMessage)
	if ( self.scanners[player] ) then
		local scanner = self.scanners[player][1];
		local marker = self.scanners[player][2];
		
		if ( IsValid(scanner) ) then
			scanner:Remove();
		end;
		
		if ( IsValid(marker) ) then
			marker:Remove();
		end;
		
		self.scanners[player] = nil;
		
		if (!noMessage) then
			player:SetMoveType(MOVETYPE_WALK);
			player:UnSpectate();
			player:KillSilent();
		end;
	end;
end;


-- A function to calculate a player's scanner think.
function Clockwork.schema:CalculateScannerThink(player, curTime)
	if ( !self.scanners[player] ) then return; end;
	
	local scanner = self.scanners[player][1];
	local marker = self.scanners[player][2];
	
	if ( IsValid(scanner) and IsValid(marker) ) then
		scanner:SetMaxHealth( player:GetMaxHealth() );
		
		player:SetMoveType(MOVETYPE_OBSERVER);
		player:SetHealth( math.max(scanner:Health(), 0) );
		
		if (!player.nextScannerSound or curTime >= player.nextScannerSound) then
			player.nextScannerSound = curTime + math.random(8, 48);
			
			scanner:EmitSound( self.scannerSounds[ math.random(1, #self.scannerSounds) ] );
		end;
	end;
end;

Clockwork.schema.scannerSounds = {
	"npc/scanner/cbot_servochatter.wav",
	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/scanner_blip1.wav",
	"npc/scanner/scanner_scan1.wav",
	"npc/scanner/scanner_scan2.wav",
	"npc/scanner/scanner_scan4.wav",
	"npc/scanner/scanner_scan5.wav",
	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav"
};
Clockwork.schema.scanners = {};

resource.AddFile("models/eliteghostcp.mdl");
resource.AddFile("models/eliteshockcp.mdl");
resource.AddFile("models/policetrench.mdl");
resource.AddFile("models/leet_police2.mdl");
resource.AddFile("models/sect_police2.mdl");

resource.AddFile("models/deadbodies/dead_male_civilian_radio.mdl");
resource.AddFile("materials/models/deadbodies/corpse_01_radio.vmt");

for k, v in pairs( _file.Find("../materials/models/police/*.*") ) do
	resource.AddFile("materials/models/police/"..v);
end;

for k, v in pairs( _file.Find("../materials/models/humans/female/group01/cityadm_sheet.*") ) do
	resource.AddFile("materials/models/humans/female/group01/"..v);
end;

for k, v in pairs( _file.Find("../materials/models/humans/male/group01/cityadm_sheet.*") ) do
	resource.AddFile("materials/models/humans/male/group01/"..v);
end;

for k, v in pairs( _file.Find("../models/humans/group17/*.mdl") ) do
	resource.AddFile("models/humans/group17/"..v);
end;

for k, v in pairs( _file.Find("../materials/halfliferp/*.*") ) do
	resource.AddFile("materials/halfliferp/"..v);
end;

resource.AddFile("sound/slidefuse/disp_rations.wav");

Clockwork:HookDataStream("EditData", function(player, data)
	if (player.editDataAuth == data[1] and type( data[2] ) == "string") then
		data[1]:SetCharacterData("CombineData", string.sub(data[2], 0, 2000));
		player.editDataAuth = nil;
	end;
end);

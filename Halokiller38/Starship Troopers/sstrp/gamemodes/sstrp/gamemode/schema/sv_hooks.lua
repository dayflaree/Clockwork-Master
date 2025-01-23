--[[
Name: "sv_hooks.lua".
Product: "Starship Troopers".
--]]

-- Called when a player attempts to use the radio.
function SCHEMA:PlayerCanRadio(player, text, listeners, eavesdroppers)
	if ( !player:GetCharacterData("frequency") ) then
		nexus.player.Notify(player, "You need to set the radio frequency first!");
		
		return false;
	end;
end;

-- Called when a player has been unragdolled.
function SCHEMA:PlayerUnragdolled(player, state, ragdoll)
	nexus.player.SetAction(player, "die", false);
end;

-- Called when a player has been ragdolled.
function SCHEMA:PlayerRagdolled(player, state, ragdoll)
	nexus.player.SetAction(player, "die", false);
end;

-- Called when a chat box message has been added.
function SCHEMA:ChatBoxMessageAdded(info)
	if (info.class == "ic") then
		local eavesdroppers = {};
		local talkRadius = nexus.config.Get("talk_radius"):Get();
		local listeners = {};
		local players = g_Player.GetAll();
		local radios = ents.FindByClass("nx_radio");
		local data = {};
		
		for k, v in ipairs(radios) do
			if (!v:IsOff() and info.speaker:GetPos():Distance( v:GetPos() ) <= 64) then
				if (info.speaker:GetEyeTraceNoCursor().Entity == v) then
					local frequency = v:GetSharedVar("sh_Frequency");
					
					if (frequency != "") then
						info.shouldSend = false;
						info.listeners = {};
						data.frequency = frequency;
						data.position = v:GetPos();
						data.entity = v;
						
						break;
					end;
				end;
			end;
		end;
		
		if (IsValid(data.entity) and data.frequency != "") then
			for k, v in ipairs(players) do
				if ( v:HasInitialized() and v:Alive() and !v:IsRagdolled(RAGDOLL_FALLENOVER) ) then
					if ( v:GetCharacterData("frequency") == data.frequency or info.speaker == v ) then
						listeners[v] = v;
					elseif (v:GetPos():Distance(data.position) <= talkRadius) then
						eavesdroppers[v] = v;
					end;
				end;
			end;
			
			for k, v in ipairs(radios) do
				if (data.entity != v) then
					local radioPosition = v:GetPos();
					local radioFrequency = v:GetSharedVar("sh_Frequency");
					
					if (!v:IsOff() and radioFrequency == data.frequency) then
						for k2, v2 in ipairs(players) do
							if ( v2:HasInitialized() and !listeners[v2] and !eavesdroppers[v2] ) then
								if ( v2:GetPos():Distance(radioPosition) <= (talkRadius * 2) ) then
									eavesdroppers[v2] = v2;
								end;
							end;
						end;
					end;
				end;
			end;
			
			if (table.Count(listeners) > 0) then
				nexus.chatBox.Add(listeners, info.speaker, "radio", info.text);
			end;
			
			if (table.Count(eavesdroppers) > 0) then
				nexus.chatBox.Add(eavesdroppers, info.speaker, "radio_eavesdrop", info.text);
			end;
		end;
	end;
end;

-- Called when a player has used their radio.
function SCHEMA:PlayerRadioUsed(player, text, listeners, eavesdroppers)
	local newEavesdroppers = {};
	local talkRadius = nexus.config.Get("talk_radius"):Get() * 2;
	local frequency = player:GetCharacterData("frequency");
	
	for k, v in ipairs( ents.FindByClass("nx_radio") ) do
		local radioPosition = v:GetPos();
		local radioFrequency = v:GetSharedVar("sh_Frequency");
		
		if (!v:IsOff() and radioFrequency == frequency) then
			for k2, v2 in ipairs( g_Player.GetAll() ) do
				if ( v2:HasInitialized() and !listeners[v2] and !eavesdroppers[v2] ) then
					if (v2:GetPos():Distance(radioPosition) <= talkRadius) then
						newEavesdroppers[v2] = v2;
					end;
				end;
				
				break;
			end;
		end;
	end;
	
	if (table.Count(newEavesdroppers) > 0) then
		nexus.chatBox.Add(newEavesdroppers, player, "radio_eavesdrop", text);
	end;
end;

-- Called when a player's radio info should be adjusted.
function SCHEMA:PlayerAdjustRadioInfo(player, info)
	for k, v in ipairs( g_Player.GetAll() ) do
		if ( v:HasInitialized() ) then
			if ( v:GetCharacterData("frequency") == player:GetCharacterData("frequency") ) then
				info.listeners[v] = v;
			end;
		end;
	end;
end;
-- Called when an entity's menu option should be handled.
function SCHEMA:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "nx_radio") then
		if (option == "Set Frequency" and type(arguments) == "string") then
			if ( string.find(arguments, "^%d%d%d%.%d$") ) then
				local start, finish, decimal = string.match(arguments, "(%d)%d(%d)%.(%d)");
				
				start = tonumber(start);
				finish = tonumber(finish);
				decimal = tonumber(decimal);
				
				if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
					entity:SetFrequency(arguments);
					
					nexus.player.Notify(player, "You have set this stationary radio's arguments to "..arguments..".");
				else
					nexus.player.Notify(player, "The radio arguments must be between 101.1 and 199.9!");
				end;
			else
				nexus.player.Notify(player, "The radio arguments must look like XXX.X!");
			end;
		elseif (arguments == "nx_radioToggle") then
			entity:Toggle();
		elseif (arguments == "nx_radioTake") then
			local success, fault = player:UpdateInventory("stationary_radio", 1);
			
			if (!success) then
				nexus.player.Notify(entity, fault);
			else
				entity:Remove();
			end;
		end;
	end;
end;

-- Called when a player's class has been set.
function SCHEMA:PlayerClassSet(player, newClass, oldClass, noRespawn, addDelay, noModelChange)
	player:SetArmor(100);
	
	--if (newClass.index == CLASS_GUARD or newClass.index == CLASS_INSURGENCY) then
		--player:SetArmor(200);
	--end;
end;

-- Called when an NPC has been killed.
function SCHEMA:OnNPCKilled(entity, attacker, inflictor)
	local class = entity:GetClass();
	local money = math.random(30, 50);
	
	if (attacker:IsPlayer()) then
		if (class == "npc_antlionguard") then
			money = math.random(250, 500);
		end;
	
		nexus.player.GiveCash(attacker, money, "Killing a npc.");
	end;
end;

-- Called when a player attempts to spawn a SWEP.
function SCHEMA:PlayerSpawnSWEP(player, class, weapon)
	if ( !player:IsAdmin() ) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player is given a SWEP.
function SCHEMA:PlayerGiveSWEP(player, class, weapon)
	if ( !player:IsAdmin() ) then
		return false;
	else
		return true;
	end;
end;

-- Called when attempts to spawn a SENT.
function SCHEMA:PlayerSpawnSENT(player, class)
	if ( !player:IsAdmin() ) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to NoClip.
function SCHEMA:PlayerNoClip(player)
	if ( player:IsRagdolled() ) then
		return false;
	elseif ( player:IsAdmin() ) then
		return true;
	else
		return false;
	end;
end;

-- Called when a player presses a key.
function SCHEMA:KeyPress(player, key)
	if (key == IN_USE) then
		local trace = player:GetEyeTraceNoCursor();
		
		if ( IsValid(trace.Entity) ) then
			if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
				if ( nexus.mount.Call("PlayerUse", player, trace.Entity) ) then
					if ( nexus.entity.IsDoor(trace.Entity) and !trace.Entity:HasSpawnFlags(256)
					and !trace.Entity:HasSpawnFlags(8192) and !trace.Entity:HasSpawnFlags(32768) ) then
						if ( nexus.mount.Call("PlayerCanUseDoor", player, trace.Entity) ) then
							nexus.mount.Call("PlayerUseDoor", player, trace.Entity);
							
							nexus.entity.OpenDoor( trace.Entity, 0, nil, nil, player:GetPos() );
						end;
					elseif (trace.Entity.UsableInVehicle) then
						if ( player:InVehicle() ) then
							if (trace.Entity.Use) then
								trace.Entity:Use(player, player);
								
								player.nextExitVehicle = CurTime() + 1;
							end;
						end;
					end;
				end;
			end;
		end;
	elseif (key == IN_WALK) then
		local velocity = player:GetVelocity():Length();
		
		if ( velocity > 0 and !player:KeyDown(IN_SPEED) ) then
			if ( player:GetSharedVar("sh_Jogging") ) then
				player:SetSharedVar("sh_Jogging", false);
			else
				player:SetSharedVar("sh_Jogging", true);
			end;
		elseif ( velocity == 0 and player:KeyDown(IN_SPEED) ) then
			if ( player:Crouching() ) then
				player:RunCommand("-duck");
			else
				player:RunCommand("+duck");
			end;
		end;
	end;
end;

-- Called when a player releases a key.
function SCHEMA:KeyRelease(player, key)
end;

concommand.Add("nx_holster", function(player)
	nexus.player.ToggleWeaponRaised(player);
end);
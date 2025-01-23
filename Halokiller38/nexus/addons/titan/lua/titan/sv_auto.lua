--[[
Name: "sv_auto.lua".
Product: "Titan".
--]]

local oldEntity = Entity;

-- A function to get an entity by its index.
function Entity(entIndex)
	if (entIndex == 0) then
		return GetWorldEntity();
	end;
	
	return oldEntity(entIndex);
end;

-- A function to clear a player's queue.
function titan:ClearPlayerQueue(player)
	self.updateQueue[player] = nil;
	
	umsg.Start("y", player);
	umsg.End();
end;

-- A function to add to the update queue.
function titan:AddToPlayerUpdateQueue(player, entity, key)
	if ( self:IsValidEntity(entity) ) then
		if ( !self.updateQueue[player] ) then
			self.updateQueue[player] = {};
		end;
		
		if ( !self.updateQueue[player][entity] ) then
			self.updateQueue[player][entity] = {};
		end;
		
		table.insert(self.updateQueue[player][entity], key);
	end;
end;

-- A function to send a full player update.
function titan:SendFullPlayerUpdate(player)
	player.fn_Vars = {};
	
	self:ClearPlayerQueue(player);
	
	for k, v in pairs(self.netVars) do
		local entity = Entity(k);
		
		if ( self:IsValidEntity(entity) ) then
			for k2, v2 in pairs(v) do
				self:AddToPlayerUpdateQueue(player, entity, k2);
			end;
		end;
	end;
end;

-- A function to update an entity's variable.
function titan:UpdateVar(entity, key, value)
	for k, v in ipairs( g_Player.GetAll() ) do
		if ( v.fn_Initialized and !self:DoesPlayerHaveVar(v, entity, key, value) ) then
			local updateEntry = tostring(entity)..tostring(key);
			
			if ( !v.fn_UpdatingList[updateEntry] ) then
				timer.Simple(FrameTime() * 16, function()
					if ( self:IsValidEntity(entity) and IsValid(v) ) then
						self:AddToPlayerUpdateQueue(v, entity, key);
						v.fn_UpdatingList[updateEntry] = nil;
					end;
				end);
			end;
		end;
	end;
end;

-- A function to get whether a player has a variable.
function titan:DoesPlayerHaveVar(player, entity, key, value)
	local entIndex = entity:EntIndex();
	
	if (player.fn_Vars[entIndex] and player.fn_Vars[entIndex][key] == value) then
		return true;
	end;
end;

-- A function to add to a player's variables.
function titan:AddPlayerVar(player, entity, key, value)
	local entIndex = entity:EntIndex();
	
	if ( !player.fn_Vars[entIndex] ) then
		player.fn_Vars[entIndex] = {};
	end;
	
	player.fn_Vars[entIndex][key] = value;
end;

-- A function to update a player's queue.
function titan:PlayerUpdateQueue(player, messageBytes, entity, key)
	local entIndex = entity:EntIndex();
	local variables = self.netVars[entIndex];
	
	if (variables and variables[key] != nil) then
		local value = variables[key];
		
		if (type(value) == "string") then
			if (string.len(value) > 200) then
				value = string.sub(value, 1, 200);
			end;
		end;
		
		if (value != nil) then
			local success, encodedData = pcall( glon.encode, {entIndex, key, value} );
			
			if (success and encodedData) then
				self:AddPlayerVar(player, entity, key, value);
				
				umsg.Start("x", player);
					umsg.String(encodedData);
				umsg.End();
				
				messageBytes = messageBytes + string.len(encodedData);
			end;
		end;
	end;
	
	return messageBytes;
end;

-- A function to initialize a player.
function titan:InitializePlayer(player)
	local curTime = CurTime();
	local nextUpdate = curTime + (FrameTime() * 64);
	
	player.fn_NextUpdateAvailable = nextUpdate;
	player.fn_NextFullUpdate = nextUpdate;
	player.fn_NextTickUpdate = 0;
	player.fn_UpdatingList = {};
	
	if (!player.fn_Initialized) then
		for k, v in ipairs(self.updateQueue) do
			if ( !self:IsValidEntity(k) ) then
				self.updateQueue[k] = nil;
			end;
		end;
		
		player.fn_Initialized = true;
		player.fn_Vars = {};
	end;
end;

-- A function to run an update queue.
function titan:RunUpdateQueue(player)
	local messageBytes = 0;
	local queue = self.updateQueue[player];
	
	if (queue) then
		for k, v in pairs(queue) do
			for k2, v2 in ipairs(v) do
				messageBytes = self:PlayerUpdateQueue(player, messageBytes, k, v2);
				
				table.remove(queue[k], k2);
				
				if (messageBytes > 1024) then
					break;
				end;
			end;
			
			if (#queue[k] == 0) then
				queue[k] = nil;
			end;
			
			if (messageBytes > 1024) then
				break;
			end;
		end;
	end;
	
	return messageBytes;
end;

hook.Add("SetupPlayerVisibility", "titan.SetupPlayerVisibility", function(player)
	if (player.fn_Initialized) then
		local curTime = CurTime();
		
		if (curTime >= player.fn_NextTickUpdate) then
			titan:RunUpdateQueue(player);
			player.fn_NextTickUpdate = FrameTime();
		end;
		
		if (player.fn_NextFullUpdate) then
			if (curTime >= player.fn_NextFullUpdate) then
				titan:SendFullPlayerUpdate(player);
				player.fn_NextFullUpdate = nil;
			end;
		end;
	end;
end);

hook.Add("OnEntityCreated", "titan.OnEntityCreated", function(entity)
	if ( titan:IsValidEntity(entity) ) then
		local entIndex = entity:EntIndex();
		
		if ( !entity.fn_IsReady or !titan.netVars[entIndex] ) then
			titan.netVars[entIndex] = {};
			entity.fn_IsReady = true;
		end;
	end;
end);

hook.Add("InitPostEntity", "titan.InitPostEntity", function()
	RunConsoleCommand("sv_usermessage_maxsize", "1024");
end);

hook.Add("PlayerInitialSpawn", "titan.PlayerInitialSpawn", function(player)
	timer.Simple(FrameTime() * 64, function()
		if ( IsValid(player) ) then
			umsg.Start("fn_UpdateReady", player);
			umsg.End();
		end;
	end);
end);

concommand.Add("fn_fullupdate", function(player, command, arguments)
	local curTime = CurTime();
	
	if (!player.fn_NextUpdateAvailable) then
		player.fn_NextUpdateAvailable = 0;
	end;
	
	if (curTime >= player.fn_NextUpdateAvailable) then
		titan:InitializePlayer(player);
	end;
end);
--================
--	Party System
--================
RP.party.created = {};
RP.party.invites = {};

-- Creates a new party.
function RP.party:Create(ply)
	if (!ply:GetParty()) then
		ply.party = {};
		
		table.insert(ply.party, ply);
		
		self.created[ply] = ply.party;
		
		RP:DataStream(ply, "createParty", {});
	else
		return false, "Player already in a party.";
	end;
end;

-- Invites a player to someones party.
function RP.party:InvitePlayer(host, ply)
	if (!ply:GetParty()) then
		if (!host:GetParty()) then
			self:Create(host);
		end;
		
		if (host != ply) then
			for k,v in ipairs(self.invites) do
				if (v.host == host and v.player == ply) then
					return false, "That player is already invited to your party!";
				end;
			end;
			
			local id = #self.invites
			table.insert(self.invites, {host = host, player = ply, id = id});
			
			RP:DataStream(ply, "partyInvite", {id, host:GetName()});
		else
			return false, "You cannot invite yourself!";
		end;
	else
		return false, Format("%s is already in a party", ply:GetName());
	end;
	
	return true;
end;

-- Accepts an invite to a party.
function RP.party:AcceptInvite(id)
	local host, ply;
	
	for k,v in ipairs(self.invites) do
		if (v.id == id) then
			host = v.host;
			ply = v.player;
			
			table.remove(self.invites, k);
		end;
	end;
	
	if (host) then
		if (#host:GetParty() <= self.max) then
			self:AddPlayer(host, ply);
			
			for k,v in ipairs(host:GetParty()) do
				v:PlaySound("buttons/button9.wav");
			end;
			
			RP:DataStream(ply, "clearAllInvites", {});
		else
			ply:Notify("That party is full!");

			RP:DataStream(ply, "removeInvite", {id});
		end;
	else
		MsgN("Host not valid in acceptInvite");
	end;
end;

-- Declines an invite to a party.
function RP.party:DeclineInvite(id)
	local host, ply;
	
	for k,v in ipairs(self.invites) do
		if (v.id == id) then
			host = v.host;
			ply = v.player;
			
			table.remove(self.invites, k);
		end;
	end;
	
	if (ply and host) then
		RP:DataStream(ply, "removeInvite", {id});
		
		for k,v in ipairs(host:GetParty()) do
			v:PlaySound("buttons/button10.wav");
		end;
		ply:PlaySound("buttons/button10.wav");
		
		host:Notify(ply:GetName().." has declined your party invite.");
	end;
end;

-- Adds a player to a party.
function RP.party:AddPlayer(host, ply)
	if (host:GetParty() and !ply:GetParty()) then
		table.insert(host:GetParty(), ply);
		ply.party = table.Copy(host:GetParty());
		
		for k,v in ipairs(ply.party) do
			RP:DataStream(ply, "joinParty", {v});
			
			if (v != ply) then
				RP:DataStream(v, "joinParty", {ply});
			end;
			v:Notify(ply:GetName().." has joined the party.");
		end;
	end;
end;

-- Ends a player's party.
function RP.party:EndParty(ply)
	local players = ply:GetParty();
	
	RP:DataStream(players, "endParty", {});
	
	for k,v in ipairs(players) do
		v.party = nil;
	end;
	
	self.created[ply] = nil;
	
	ply.party = nil;
end;

-- Removes a player from a party.
-- function RP.party:RemovePlayer(host, ply, message)
	-- local players = host:GetParty();
	
	-- ply.party = nil;
	-- message = message or Format("%s has left the party.", ply:GetName());
	
	-- RP:DataStream(players, "playerLeaveParty", {ply, message});
	
	-- table.remove(players, table.KeyFromValue(players, ply));
	
	-- for k,v in ipairs(players) do
		-- local key = table.KeyFromValue(v:GetParty(), ply);
		-- table.remove(v:GetParty(), key);
	-- end;
-- end;

-- Removes a player from their party.
function RP.party:RemovePlayer(host, ply, message)
	local players = table.Copy(ply:GetParty());
	message = message or Format("%s has left the party.", ply:GetName());
	
	RP:DataStream(players, "playerLeaveParty", {ply, message});
	
	for k,v in ipairs(players) do
		for a,b in ipairs(v:GetParty()) do
			if (b == ply) then
				table.remove(v.party, a);
			end;
		end;
	end;
	
	ply.party = nil;
end;

-- Makes a player the leader of their party.
function RP.party:MakeLeader(ply)
	local players = ply:GetParty();
	
	if (players) then
		local curKey = table.KeyFromValue(players, ply);
		local oldLeader = players[1];
		
		for k,v in ipairs(players) do
			v.party[1] = ply;
			v.party[curKey] = oldLeader;
		end;
		
		RP:DataStream(players, "newPartyLeader", {ply});
	else
		return false, "That player is not in a party.";
	end;
end;

RP:DataHook("partyAccept", function(ply, data)
	local id = data[1];
	
	RP.party:AcceptInvite(id);
end);

RP:DataHook("partyDecline", function(ply, data)
	local id = data[1];
	
	RP.party:DeclineInvite(id);
end);

local playerMeta = FindMetaTable("Player");

function playerMeta:GetParty()
	local party = self.party;
	
	if (party) then
		for k,v in ipairs(party) do
			if (!ValidEntity(v)) then
				table.remove(party, k);
			end;
		end;
	end;
	
	return party;
end;

function playerMeta:IsPartyLeader()
	local party = self:GetParty();
	
	if (party) then
		if (party[1] == self) then
			return true;
		end;
	end;
	
	return false;
end;

function playerMeta:InParty(host)
	if (host:GetParty()) then
		if (table.HasValue(host:GetParty(), self)) then
			return true;
		end;
	end;
	
	return false;
end;

-- hook.Add("PlayerDisconnected", "removeFromPartyOnDC", function(ply)
	-- if (ply:GetParty()) then
		-- for k,v in ipairs(ply:GetParty()) do
			-- table.remove(v.party, table.KeyFromValue(v:GetParty(), ply));
		-- end;
	-- end;
-- end);

local PLUGIN = PLUGIN;
PLUGIN.WarpLocations = {};
PLUGIN.channels = {};

-- Helper function to check if a player's cursor is aiming near a location
local function IsAimingAt(origin, dir, pos, dist)
	local newPos = origin + (dir * origin:Distance(pos));
	local currDist = newPos:Distance(pos);

	return currDist <= dist;
end;

-- Save the warps
function PLUGIN:SaveWarps()
	Clockwork.kernel:SaveSchemaData("plugins/vortport/" .. game.GetMap(), self.WarpLocations);
end;

-- Load the warps
function PLUGIN:LoadWarps()
	self.WarpLocations = Clockwork.kernel:RestoreSchemaData("plugins/vortport/" .. game.GetMap());
end;

-- Emit playerside sounds, because playing them playerside gives sounds a larger range
-- Emitting it serverside would only make large groups of people go deaf
function PLUGIN:EmitplayerSound(name, level, pitch, volume)
	Clockwork.datastream:Start(nil, "vortPortSound", {name, level, pitch, volume});
end;

-- Create a new 'channel master.' This should only be called once on a player, once per teleport group
function PLUGIN:BeginChannel(player, location, buddy, index)
	if (IsValid(player)) then
		self.channels[index] = true;
		player:SetSharedVar("vIndex", index);
		player:SetSharedVar("vortChanneling", true);
		player:SetSharedVar("vortDest", location);

		if (IsValid(buddy)) then
			player:SetSharedVar("vortBuddy", buddy);
			buddy:SetSharedVar("vIndex", index);
			buddy:SetSharedVar("vortDest", location);
			buddy:SetSharedVar("vortChanneling", true);
		end;
	end;
end;

-- Find a suitable channel to join. Don't allow people to piggyback off of existing in-progress channels
function PLUGIN:FindChannelToJoin(player, destination)
	for k, v in pairs(cwPlayer.GetAll()) do
		if (v:GetSharedVar("vortDest") == destination and v:GetPos():Distance(player:GetPos()) <= self.ChannelDist and !timer.Exists("VortChannel" .. v:GetSharedVar("vIndex"))) then
			player:SetSharedVar("vortDest", destination);
			player:SetSharedVar("vIndex", v:GetSharedVar("vIndex"));
			player:SetSharedVar("vortChanneling", true);
			Clockwork.player:Notify(player, "You begin to channel the Vortessence with your kin...");
			self:CheckWarpStatus(v:GetSharedVar("vIndex"));
			return;
		end;
	end;
end;

-- Convenience function to retrieve all users connected to a channel
function PLUGIN:GetChannelUsers(index)
	local players = {};

	for k, v in pairs(player.GetAll()) do
		if (v:GetSharedVar("vIndex") == index) then
			table.insert(players, v);
		end;
	end;
	return players;
end;

-- Convenience function to get the warp name of a channel group
function PLUGIN:GetChannelDestination(index)
	return self:GetChannelUsers(index)[1]:GetSharedVar("vortDest") or "";
end;

-- Convenience function to check the number of vortigaunts attached to a channel
function PLUGIN:GetChannelVortCount(index)
	local vortcount = 0;

	for k, v in pairs(self:GetChannelUsers(index)) do
		if (v:GetFaction():find("Vortigaunt")) then
			vortcount = vortcount + 1;
		end;
	end;
	return vortcount;
end;


-- Begin the appropriate timers and get ready for warp!
function PLUGIN:InitiateWarp(index, location)
	local pos = vector_origin
	-- Where are they actually headed? Find out!
	for k, v in pairs(self.WarpLocations) do
		if (v.name == location) then
			pos = v.pos;
		end;
	end;

	timer.Create("VortChannel" .. index, self.TeleportDelay, 1, function()
		local chanusers = self:GetChannelUsers(index);

		for k, v in pairs(chanusers) do
			if !(v:Alive()) then
				self:FailWarp(v, "Channeling cancelled due to the death of a participant.");
				return;
			end;
		end;

		if (#chanusers >= self.MinimumVorts and self:GetChannelVortCount(index) >= self.MinimumVorts) then
			for _, v in pairs(chanusers) do
				local decalstart = v:GetPos() + Vector(0, 0, 10);
				local decalend = v:GetPos() - Vector(0, 0, 10);
				local decalstart2 = pos + Vector(0, 0, 10);
				local decalend2 = pos - Vector(0, 0, 10);

				-- Blind people at the beginning zone
				for _, v2 in pairs(player.GetAll()) do
					local t = {};

					t.start = v2:EyePos();
					t.endpos = v:EyePos();
					t.filter = v2;
					t.mask = MASK_OPAQUE;
					local trace = util.TraceLine(t);

					if (trace.Entity and trace.Entity == v and IsAimingAt(v2:EyePos(), v2:EyeAngles():Forward(), v:GetPos(), 100)) then
						v2:ScreenFade(SCREENFADE.IN, Color(216, 255, 218), 0.15, 0.1);
					end;
				end;

				-- Apply the decal at the arrival zone
				util.Decal("Scorch", decalstart2, decalend2);

				v:ScreenFade(SCREENFADE.IN, Color(216, 255, 218), 0.15, 0.1);
				v:SetNotSolid(true); -- Do this or else they'll all get stuck in the same spot
				v:SetPos(pos);
				sound.Play("npc/strider/fire.wav", pos, 85, 70, 0.4);

				-- Apply the decal at 'ground zero'
				util.Decal("Scorch", decalstart, decalend);

				-- Some thunder for ambience
				self:EmitplayerSound("ambient/levels/labs/teleport_postblast_thunder1.wav", 75, math.random(90,110), 0.2);

				-- Blind people at the arrival zone
				for _, v2 in pairs(player.GetAll()) do
					local t = {};
					t.start = v2:EyePos();
					t.endpos = v:EyePos();
					t.filter = v2;
					t.mask = MASK_OPAQUE;
					local trace = util.TraceLine(t);

					if (trace.Entity and trace.Entity == v and IsAimingAt(v2:EyePos(), v2:EyeAngles():Forward(), v:GetPos(), 100)) then
						v2:ScreenFade(SCREENFADE.IN, Color(216, 255, 218), 0.15, 0.1);
					end;
				end;

				timer.Simple(3, function()
					if (IsValid(v)) then
						v:SetNotSolid(false); -- Make them solid again so they collide with each other
					end;
				end);

				v:SetSharedVar("vortChannelCooldown", CurTime() + self.TeleportCooldown);
			end;

			self:StopChannel(index);
		end;
	end);
end;

--[[
Run every time a new player joins in on the warp.
If the body count is greater than the minimum vort count and there are at least x vortigaunts, begin channeling

]]
function PLUGIN:CheckWarpStatus(index)
	local vortcount = 0;

	for k, v in pairs(player.GetAll()) do
		if (v:GetSharedVar("vIndex") == index and v:GetFaction():find("Vortigaunt")) then
			vortcount = vortcount + 1;
		end;
	end;

	if (vortcount >= self.MinimumVorts and !timer.Exists("VortChannel" .. index)) then
		local location = self:GetChannelDestination(index);

		for k, v in pairs(self:GetChannelUsers(index)) do
			Clockwork.player:Notify(v, "The Vortessence is answering your call...");
		end;

		self:InitiateWarp(index, location);
	end;
end;

-- Check if a channel has an elder, so the teleport can commence
function PLUGIN:ChannelHasElder(index)
	for k, v in pairs(self:GetChannelUsers(index)) do
		for k2, _ in pairs(self.ElderNames) do
			if (v:Name():find(k2)) then
				return true;
			end;
		end;
	end;
end;

-- Stops the channeling timer and resets all variables
function PLUGIN:StopChannel(index)
	for k, v in pairs(player.GetAll()) do
		if (v:GetSharedVar("vIndex") == index) then
			self.colortracker[v] = nil;
			v:SetSharedVar("vortChanneling", false);
			v:SetSharedVar("vortDest", nil);
			v:SetSharedVar("vIndex", nil);
			v:SetColor(color_white);
		end;
	end;

	self.channels[index] = nil;
	timer.Remove("VortChannel" .. index);
end;

-- Stop a channel because of a certain player. Basically StopChannel, but takes a player argument, and accepts a custom fail message
function PLUGIN:FailWarp(player, msg)
	if (player:GetSharedVar("vortChanneling")) then
		local index = player:GetSharedVar("vIndex");
		local buddy = player:GetSharedVar("vortBuddy");
		self.channels[index] = false
		self.colortracker[player] = nil

		Clockwork.player:Notify(player, msg or "Channeling cancelled due to movement...");
		player:SetSharedVar("vortChanneling", false);
		player:SetSharedVar("vortDest", nil);
		timer.Remove("VortChannel" .. index);
		player:SetSharedVar("vIndex", nil);
		player:SetColor(color_white);

		if (IsValid(buddy)) then
			self.colortracker[buddy] = nil;
			buddy:SetSharedVar("vortChanneling", false);
			buddy:SetSharedVar("vortDest", nil);
			buddy:SetSharedVar("vIndex", nil);
			buddy:SetColor(color_white);
		end

		player:SetSharedVar("vortBuddy", nil)

		for k, v in pairs(cwPlayer.GetAll()) do
			if (v:GetSharedVar("vortChanneling") and v:GetSharedVar("vortChannelIndex") == player:GetSharedVar("vortChannelIndex")) then
				self.colortracker[v] = nil;
				Clockwork.player:Notify(v, msg or "Channeling cancelled due to movement...");
				v:SetSharedVar("vortChanneling", false);
				v:SetSharedVar("vortDest", nil);
				v:SetSharedVar("vIndex", nil);
				v:SetColor(color_white);
			end;
		end;
	end;
end;

PLUGIN:LoadWarps();
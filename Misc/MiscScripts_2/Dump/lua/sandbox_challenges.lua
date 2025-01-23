local Player = _R.Player

function Player:StartChallenge(id)
	local c = challenge.Get(id)
	
	local cs = not self:DoingChallenge() and c.CanPlayerStart(self)
	if cs then
		self._CC = id
		self:CurrentChallenge().PlayerStart(self)
		self:SendLua('LocalPlayer()._CC = "' .. id .. '"')
	else
		MsgN(cs)
	end
end

function Player:EndChallenge(finished)
	if finished then
		self:CurrentChallenge().PlayerFinish(self)
		MsgN("Congrats, you finished the challenge!")
	else
		self:CurrentChallenge().PlayerEnd(self)
		MsgN("You cancelled the challenge!")
	end
	
	self._CC = nil
end

hook.Add("Think", "SandboxChallengesThink", function()
	for _, ply in pairs(player.GetAll()) do
		if ply:DoingChallenge() then
			if ply:CurrentChallenge().Think(ply) then
				ply:EndChallenge(true)
			end
		end
	end
end)

for _, name in pairs({ "CanTool", "PlayerSpawnProp", "PlayerSpawnSENT", "PlayerSpawnSWEP", "PlayerSpawnVehicle", "PlayerSpawnNPC", "PlayerSpawnEffect", "PlayerNoClip", "PlayerSpawn", "PlayerLoadout", "PlayerSwitchFlashlight", "CanPlayerEnterVehicle" }) do
	hook.Add(name, "SandboxChallenges" .. name, function(ply, ...)
		if ply:DoingChallenge() then
			local c = ply:CurrentChallenge()
			
			if c.Hooks and c.Hooks[name] then
				return c.Hooks[name](ply, ...)
			end
		end
	end)
end

concommand.Add("startchallenge", function(ply, cmd, args)
	
end)

concommand.Add("cancelchallenge", function(ply, cmd, args)
	
end)

concommand.Add("finishchallenge", function(ply, cmd, args)
	
end)
	
	
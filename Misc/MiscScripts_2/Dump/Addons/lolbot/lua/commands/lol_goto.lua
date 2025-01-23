local CMD = {}

CMD.Command = "goto"

function CMD.RunFunction(ply, args)
	if not lolbot.NPC then return end
	
	local togoto = false
	
	if lolbot.ToSelf(args[1], ply) then
		togoto = ply
	elseif lolbot.FindPlayer(args[1]) then
		togoto = lolbot.FindPlayer(args[1])
	end
	
	if togoto then
		lolbot.Reply("Going to " .. togoto:Nick(), function()
			local pos = togoto:GetPos() + (VectorRand() * math.random(50, 100))
			pos.z = togoto:GetPos().z
			lolbot.NPC:SetLastPosition(pos)
			lolbot.NPC:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end
end

lolbot:Register(CMD)
local CMD = {}

CMD.Command = "kill"

function CMD.RunFunction(ply, args)
	local tokill = false
	local reason = ""
	
	if lolbot.ToSelf(args[1], ply) then
		tokill = ply
		reason = "Whatever you say..."
	elseif lolbot.FindPlayer(args[1]) and ply > lolbot.FindPlayer(args[1]) then
		tokill = lolbot.FindPlayer(args[1])
		reason = ply:Nick(true) .. " told me to :<"
	end
	
	if tokill then
		lolbot.Reply(reason, function() tokill:Kill() end)
	end
end

lolbot:Register(CMD)
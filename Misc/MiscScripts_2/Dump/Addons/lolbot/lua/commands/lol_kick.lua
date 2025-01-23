local CMD = {}

CMD.Command = "kick"

function CMD.RunFunction(ply, args)
	local tokick = false
	local reason = ""
	
	if lolbot.ToSelf(args[1], ply) then
		tokick = ply
		reason = "Whatever you say..."
	elseif lolbot.FindPlayer(args[1]) and ply > lolbot.FindPlayer(args[1]) then
		tokick = lolbot.FindPlayer(args[1])
		reason = ply:Nick(true) .. " told me to :<"
	end
	
	if tokick then
		lolbot.Reply(reason, function() tokick:Kick(reason) end)
	end
end

lolbot:Register(CMD)
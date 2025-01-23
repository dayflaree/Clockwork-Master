local CMD = {}

CMD.Command = "say"

function CMD.RunFunction(ply, args)
	local text = table.concat(args, " ")
	lolbot.Reply(text)
end

lolbot:Register(CMD)
local CMD = {}

CMD.Command = "setname"

function CMD.RunFunction(ply, args)
	if ply:IsAdmin() then
		lolbot.name = args[1]
		lolbot.Reply("My name is now ".. args[1])
	end
end

lolbot:Register(CMD)
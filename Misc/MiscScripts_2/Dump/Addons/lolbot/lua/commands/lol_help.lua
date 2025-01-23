local CMD = {}

CMD.Command = "help"

function CMD.RunFunction(ply, args)
	local cmds = lolbot.commands
	local commands = {}
	for k, v in pairs(cmds) do
		table.insert(commands, v.Command)
	end
	lolbot.Reply(ply:Nick(true) .. ": " .. table.concat(commands, ", "))
end

lolbot:Register(CMD)
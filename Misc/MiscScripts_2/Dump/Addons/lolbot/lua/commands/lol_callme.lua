local CMD = {}

CMD.Command = "callme"

function CMD.RunFunction(ply, args)
	if #args < 1 then
		lolbot.Reply(ply:Nick(true) .. ": Sorry, your alias has too few words!")
	elseif #args > 1 then
		lolbot.Reply(ply:Nick(true) .. ": Sorry, your alias has too many words!")
	else
		local alias = args[1]
		ply:SetPData("lolbot_alias", alias)
		lolbot.Reply(name .. ": I will refer to you as " .. ply:Nick() .. " from now on!")
	end
end

lolbot:Register(CMD)
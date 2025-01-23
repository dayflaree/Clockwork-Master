local CMD = {}

CMD.Command = "calc"

function CMD.RunFunction(ply, args)
	local str = table.concat(args, "+")
	http.Get("http://undefined.phobile.net/lolbot/calc.php?q="..str, "", lolbot.CallBack)
end

lolbot:Register(CMD)
local CMD = {}

CMD.Command = "define"

function CMD.RunFunction(ply, args)
	local str = table.concat(args, "+")
	http.Get("http://undefined.phobile.net/lolbot/google.php?q="..str, "", lolbot.CallBack)
end

lolbot:Register(CMD)
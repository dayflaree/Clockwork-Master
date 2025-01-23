local CMD = {}

CMD.Command = "run"

function CMD.RunFunction(ply, args)
	http.Get("http://undefined.phobile.net/lolbot/"..args[1]..".php", "", lolbot.CallBack)
end

lolbot:Register(CMD)
function EA.NotifyHook(str)
	chat.AddText(Color(255, 120, 0, 255), "[EA] ", Color(255, 255, 255, 255), str)
end
usermessage.Hook("EA_Notify", function(um) EA.NotifyHook(um:ReadString()) end)


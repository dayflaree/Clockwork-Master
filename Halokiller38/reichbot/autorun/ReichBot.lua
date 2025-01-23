/*-------------------------------------------------------------------------------
	SV bypass module features

	Someone forgot to add speedhack from integra.
*/-------------------------------------------------------------------------------
concommand.Add("rb_cheats", function(p, c, args)
	require("bypass")	
if cvar2 then
	if cvar2.SetValue then
		cvar2.SetValue("sv_cheats", "1")
	else
		MsgN("SV bypass module not found")
	end
end
end)

concommand.Add("rb_consistency", function(p, c, args)
	require("bypass")	
if cvar2 then
	if cvar2.SetValue then
		cvar2.SetValue("sv_consistency", "0")
	else
		MsgN("SV bypass module not found")
	end
end
end)

concommand.Add("rb_hldj", function(p, c, args)
	require("bypass")	
if cvar2 then
	if cvar2.SetValue then
		cvar2.SetValue("sv_allow_voice_from_file", "1")
	else
		MsgN("SV bypass module not found")
	end
end
end)
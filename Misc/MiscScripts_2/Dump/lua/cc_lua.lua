function MsgAdmins(text)
	for k, ply in pairs(player.GetAll()) do
		if ply:IsAdmin() then
			ply:SendLua(string.format('chat.AddText(Color(255, 67, 0), "[LuaServer] ", Color(255, 255, 255), %q)', text))
		end
	end
end

concommand.Add("sv_lua", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		RunString(table.concat(args, " "))
	end
end)

concommand.Add("sv_lua_openscript", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		MsgAdmins('Including file: ' .. table.concat(args, ' ') .. '.lua')
		MsgN('[LuaServer] Including file: ' .. table.concat(args, ' ') .. '.lua')
		include(table.concat(args, " ") .. ".lua")
	end
end)


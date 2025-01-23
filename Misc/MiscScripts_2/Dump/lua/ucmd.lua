-- SERVER
usercommand = {}

usercommand.Hook = function(name, func)
	
end

usercommand.Call = function(name, 

concommand.Add("ucmd", function(ply, cmd, args)
	local parts = string.split(table.concat(args, " "), "#|#")
	PrintTable(parts)
end)

-- CLIENT
ucmd = {}
ucmd.buffer = ""

ucmd.Start = function(name)
	ucmd.buffer = ""
end

ucmd.String = function(str)
	
end

ucmd.End = function()
	-- Send it
	LocalPlayer():ConCommand("ucmd", table.concat(umcd.buffer, "#|#"))
end


-------------------------------------------------------------------------------------------


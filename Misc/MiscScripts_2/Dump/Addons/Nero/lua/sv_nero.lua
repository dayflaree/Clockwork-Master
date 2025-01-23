function NERO.PlayerInitialSpawn(ply)
	--self.NERO = {}
	--self.NERO.Config = glon.decode(self:GetPData("NERO_Config")) or {}
end

hook.Add("PlayerInitialSpawn", "NERO_PlayerInitialSpawn", NERO.PlayerInitialSpawn)

NERO.Commander = function(ply, cmd, args)
	for p_name, PLUGIN in pairs(NERO.Plugins) do
		for c_name, func in pairs(PLUGIN.Commands) do
			if string.lower(c_name) == args[1] then
				if ply:HasPermission(PLUGIN.Permissions[c_name]) then
					table.remove(args, 1)
					local imp = table.concat(args, " ")
					local exp = string.Explode("#|#", imp)
					
					if exp[1] == "" then
						exp[1] = nil
					end
					
					--[[ if command.Arguments then
						for num, arg in pairs(command.Arguments) do
							if arg.Required and not exp[num] then
								Error("Required argument '" .. arg.Name .. "' not provided for in call to '" .. c_name .. "'!")
							elseif not arg.Required and not exp[num] and arg.Default then
								exp[num] = arg.Default
							end
							
							if arg.Type == "PlayerTable" then
								exp[num] = NERO.FindPlayers(exp[num])
							elseif arg.Type and not table.HasValue(arg.Type, type(exp[num])) then
								Error("Provided argument '" .. arg.Name .. "' in call to '" .. c_name .. "' has an invalid type! Got " .. type(exp[num]) .. ", expecting " .. table.concat(arg.Type, ", ") .. "!")
							end
						end
					end ]]
					
					return func(ply, unpack(exp))
				end
			end
		end
	end
end

concommand.Add("nero", NERO.Commander)
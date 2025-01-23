local AA = {}
AA.__index = AA

AA.Hooks = {
	Initialize = function()
		-- Load Ranks
		AA.Ranks = AA:GetSetting("AA_Ranks")
	end,
	
	PlayerInitialSpawn = function(ply)
		ply.Rank = ply:GetPData("AA_Rank") or AA:GetSetting("AA_Default_Rank")
		ply.Permissions = ply:GetPData("AA_Permissions") or {}
	end
}

for Name, Function in pairs(AA.Hooks) do
	-- hook.Add(Name, "AA_" .. Name, Function)
end

-- for k, PLUGIN in pairs(AA.Plugins) do
	-- if PLUGIN.Hooks then
		-- for Name, Function in pairs(PLUGIN.Hooks) do
			-- hook.Add(Name, "AA_" .. k .. "_" .. Name, Function)
		-- end
	-- end
-- end
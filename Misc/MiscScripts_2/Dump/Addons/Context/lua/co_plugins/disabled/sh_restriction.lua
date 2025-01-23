local PLUGIN = {}

PLUGIN.Name = "SWEPs, STOOLs and SENTs Restriction"

PLUGIN.Menu = {
	World = {
		function(menu)
			local rmenu = menu:AddSubMenu("Restrict"):SetIcon("wrench")
			rmenu:AddOption("SWEPs", function() RunCommand("get_sweps_restriction") end)
			rmenu:AddOption("STOOLSs", function() RunCommand("get_stools_restriction") end)
			rmenu:AddOption("SENTs", function() RunCommand("get_sents_restriction") end)
		end
	}
}

PLUGIN.Commands = {
	get_sweps_restriction = function(ply, args)
		local sweps = {}
		-- find all sweps
		-- send via datastream
	end,
	
	get_stools_restriction = function(ply, args)
		local stools = {}
		-- find all stools
		-- send via datastream
	end,
	
	get_sents_restriction = function(ply, args)
		local sents = {}
		-- find all sents
		-- send via datastream
	end,
	
	set_sweps_restriction = function(ply, args)
		local swep = args[1]
		local group = args[2]
		-- Save to config
	end,
	
	set_stools_restriction = function(ply, args)
		local stool = args[1]
		local group = args[2]
		-- Save to config
	end,
	
	set_sents_restriction = function(ply, args)
		local sent = args[1]
		local group = args[2]
		-- Save to config
	end,
}

PLUGIN.Hooks = {
	Initialize = function()
		for _, swep in pairs(file.FindDir("../lua/weapons/*")) do
			if not CONTEXT:GetConfigItem("restrictions_swep_" .. swep, false) then
				CONTEXT:SetConfigItem("restrictions_swep_" .. swep, { 0 })
			end
		end
		
		for _, stool in pairs(file.FindInLua("weapons/gmod_tool/stools/*.lua")) do
			if not CONTEXT:GetConfigItem("restrictions_stool_" .. stool, false) then
				CONTEXT:SetConfigItem("restrictions_stool_" .. stool, { 0 })
			end
		end
		
		for _, sent in pairs(file.FindDir("../lua/entities/*")) do
			if not CONTEXT:GetConfigItem("restrictions_sent_" .. sent, false) then
				CONTEXT:SetConfigItem("restrictions_sent_" .. sent, { 0 })
			end
		end
	end,
	
	CanTool = function(ply, trace, toolmode)
		if table.HasValue(CONTEXT:GetConfigItem("restrictions_stool_" .. toolmode, {}), ply:GetGroup()) then
			return true
		else
			CONTEXT.Notify(ply, "You are not allowed to use this stool!")
			return false
		end
	end,
	
	PlayerSpawnSWEP = function(ply, classname, weapon)
		if table.HasValue(CONTEXT:GetConfigItem("restrictions_swep_" .. classname, {}), ply:GetGroup()) then
			return true
		else
			CONTEXT.Notify(ply, "You are not allowed to use this swep!")
			return false
		end
	end,
	
	PlayerGiveSWEP = function(ply, classname, weapon)
		if table.HasValue(CONTEXT:GetConfigItem("restrictions_swep_" .. classname, {}), ply:GetGroup()) then
			return true
		else
			CONTEXT.Notify(ply, "You are not allowed to use this swep!")
			return false
		end
	end,
	
	PlayerSpawnSENT = function(ply, classname)
		if table.HasValue(CONTEXT:GetConfigItem("restrictions_sent_" .. classname, {}), ply:GetGroup()) then
			return true
		else
			CONTEXT.Notify(ply, "You are not allowed to use this sent!")
			return false
		end
	end
}

CONTEXT:RegisterPlugin(PLUGIN)
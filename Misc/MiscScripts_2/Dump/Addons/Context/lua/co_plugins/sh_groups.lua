local PLUGIN = {}

PLUGIN.Name = "Groups"

PLUGIN.Menu = {
	World = {
		function(menu)
			local gmenu = menu:AddSubMenu("Groups"):SetIcon("group")
			gmenu:AddOption("New Group", function() Derma_StringRequest("New group name", "What should the new group be named?", "", function(text) RunCommand("addgroup", text) end) end):SetIcon("add")
			gmenu:AddSpacer()
			local gsmenu = gmenu:AddSubMenu("Edit Group")
			for _, group in pairs(CONTEXT:GetConfigItem("Groups", {})) do
				gsmenu:AddOption(group.Name, function() end)
			end
		end
	},
	
	Player = {
		function(menu, ply)
			local gmenu = menu:AddSubMenu("Set Group"):SetIcon("group")
			for _, group in pairs(CONTEXT:GetConfigItem("Groups", {})) do
				gmenu:AddOption(group.Name, function() RunCommand("setgroup", ply:UniqueID(), group.ID) end)
			end
		end
	}
}

PLUGIN.Extend = {
	Player = {
		Server = {
			SetGroup = function(self, id)
				self:SetNWVar("context_group", id)
			end
		},
		
		Shared = {
			GetGroup = function(self)
				return self:GetNWInt("context_group", 0)
			end
		}
	}
}

PLUGIN.Commands = {
	addgroup = function(ply, args)
		local groupname = args[1]
		
		if not groupname then return end
		
		local groups = CONTEXT:GetConfigItem("Groups", {})
		
		table.insert(groups, {Name = groupname})
		
		CONTEXT:SetConfigItem("Groups", groups, true)
		
		CONTEXT.Notify(nil, ply, " added group " .. groupname .. "!")
	end,
	
	setgroup = function(ply, args)
		local to_set = Entity(args[1])
		local group = args[2]
		
		if not to_set or not group then return end
		
		CONTEXT:SetConfigItem(ply:UniqueID() .. "group", group)
		
		CONTEXT.Notify(nil, ply, " set ", to_set, "'s group to ", group)
	end
}

CONTEXT.GetGroupID = function(name)
	return 6
end

CONTEXT:RegisterPlugin(PLUGIN)
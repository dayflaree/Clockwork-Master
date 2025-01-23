local PLUGIN = {}
PLUGIN.Name = "Perma Props"
PLUGIN.Author = "_Undefined"
PLUGIN.Dependencies = { "datasaving" }
PLUGIN.Permissions = { AddProp = "Add Perma Prop", RemoveProp = "Remove Perma Prop" }

PLUGIN.Commands = {
	AddProp = function(ply)
		local ent = ply:GetEyeTrace().Entity
		if ent and ValidEntity(ent) then
			
		end
	end,
	RemoveProp = function(ply)
		local ent = ply:GetEyeTrace().Entity
		if ent and ValidEntity(ent) then
			if not ent.IsPermaProp then return end
			
		end
	end
}

PLUGIN.Hooks = {
	InitPostEntity = function()
		--[[ local props = NERO:Get("permaprops", {})
		
		for _, prop in pairs(props) do
			local p = ents.Create(prop.Class)
			-- more
		end ]]
	end
}

NERO:RegisterPlugin(PLUGIN)
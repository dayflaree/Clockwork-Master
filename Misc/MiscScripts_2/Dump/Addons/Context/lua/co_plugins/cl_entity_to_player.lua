local PLUGIN = {}

PLUGIN.Name = "Entity to Player Menu"
PLUGIN.Description = "Shows a player menu for the owner of the entity you opened the context menu on. Requires some form of prop protection, but will fail gracefully if none is detected."

PLUGIN.Menu = {
	Entity = {
		function(menu, ent)
			for _, ply in pairs(player.GetAll()) do
				if ent:GetNWString("owner") == ply:Nick() then
					local pmenu = menu:AddSubMenu(ply:Nick())
					CONTEXT:PlayerMenu(pmenu, ply)
				end
			end
		end
	}
}

CONTEXT:RegisterPlugin(PLUGIN)
local PLUGIN = {}

PLUGIN.Name = "Prop Fun"

PLUGIN.Menu = {
	Entity = {
		function(menu, ent)
			menu:AddOption("Fling", function() RunCommand("fling", ent:EntIndex()) end)
		end,
		function(menu, ent)
			menu:AddOption("Bring", function() RunCommand("bring", ent:EntIndex()) end)
		end,
		function(menu, ent)
			menu:AddSpacer()
		end
	}
}

PLUGIN.Commands = {
	fling = function(ply, args)
		local e = Entity(args[1])
		
		if e and e:IsValid() then
			e:GetPhysicsObject():SetVelocity(ply:GetForward() * 500 + Vector(0, 0, 500))
		end
	end,
	bring = function(ply, args)
		local e = Entity(args[1])
		
		if e and e:IsValid() then
			e:GetPhysicsObject():SetVelocity(ply:GetForward() * -500 + Vector(0, 0, 500))
		end
	end
}

CONTEXT:RegisterPlugin(PLUGIN)
local PLUGIN = {}

PLUGIN.Name = "Kill"
PLUGIN.Description = "Provides numerous ways to kill a player."

PLUGIN.Menu = {
	Player = {
		function(menu, ply)
			kmenu = menu:AddSubMenu("Kill")
			kmenu:AddOption("Slay", function() RunCommand("kill", ply:EntIndex(), "slay") end)
			kmenu:AddOption("Explode", function() RunCommand("kill", ply:EntIndex(), "explode") end)
			kmenu:AddOption("Rocket", function() RunCommand("kill", ply:EntIndex(), "rocket") end)
			kmenu:AddOption("Trainfuck", function() RunCommand("kill", ply:EntIndex(), "trainfuck") end)
		end
	}
}

PLUGIN.Commands = {
	kill = function(ply, args)
		local to_kill = Entity(args[1])
		local method = args[2]
		
		if to_kill and to_kill:IsValid() and to_kill:IsPlayer() then
			if method == "slay" then
				to_kill:Kill()
				CONTEXT.Notify(nil, ply, " slayed ", to_kill)
			elseif method == "explode" then
				local effect = EffectData()
					effect:SetOrigin(to_kill:GetPos())
					effect:SetStart(to_kill:GetPos())
					effect:SetMagnitude(1024)
					effect:SetScale(256)
				util.Effect("Explosion", effect)
				util.BlastDamage(ply, ply, ply:GetPos(), 150, 150)
				timer.Simple(0.1, function() to_kill:Kill() end)
				CONTEXT.Notify(nil, ply, " blew up ", to_kill)
			elseif method == "rocket" then
				to_kill:SetMoveType(MOVETYPE_WALK)
				to_kill:SetVelocity(Vector(0, 0, 2048))
				
				trail = util.SpriteTrail(to_kill, 0, team.GetColor(to_kill:Team()), false, 128, 64, 3, 0.5, "trails/smoke.vmt")
				SafeRemoveEntityDelayed(trail, 3)
				
				timer.Simple(3, function()
					local effect = EffectData()
						effect:SetOrigin(to_kill:GetPos())
						effect:SetStart(to_kill:GetPos())
						effect:SetMagnitude(1024)
						effect:SetScale(256)
					util.Effect("Explosion", effect)
					timer.Simple(0.1, function() to_kill:Kill() end)
				end)
				CONTEXT.Notify(nil, ply, " rocketed ", to_kill)
			elseif method == "trainfuck" then
				local train = ents.Create( "prop_physics" )
				train:SetModel("models/props_trainstation/train001.mdl")
				train:SetAngles((to_kill:GetForward() * -1):Angle() + Angle(0, -90, 0))
				train:SetPos(to_kill:GetPos() + to_kill:GetForward() * 2000 + Vector(0, 0, 200))
				train:Spawn()
				train:Activate()
				train:EmitSound("ambient/alarms/train_horn2.wav", 100, 100)
				train:GetPhysicsObject():SetVelocity((to_kill:GetForward() * -1) * 50000)
				
				timer.Simple(0.5, function() to_kill:SetMoveType(MOVETYPE_WALK) end)
				
				timer.Simple(1, function() to_kill:ChatPrint("T-T-T-T-TRAINFUCKED!") end)
				
				timer.Create("TrainRemove_"..CurTime(), 5, 1, function(train) train:Remove() end, train)
			end
		end
	end
}

CONTEXT:RegisterPlugin(PLUGIN)
local CMD = {}

CMD.Command = "smite"

function CMD.RunFunction(ply, args)
	local tosmite = false
	local reason = ""
	
	if lolbot.ToSelf(args[1], ply) then
		tosmite = ply
		reason = "Whatever you say..."
	elseif lolbot.FindPlayer(args[1]) and ply > lolbot.FindPlayer(args[1]) then
		tosmite = lolbot.FindPlayer(args[1])
		reason = ply:Nick(true) .. " told me to :<"
	end
	
	if tosmite then
		lolbot.Reply(reason, function()
			local tn = "lightning" .. tosmite:EntIndex()
			tosmite:SetKeyValue("targetname", tn)
			tosmite:EmitSound(Sound("ambient/explosions/explode_2.wav"))
			for i = 1, 20 do
				local l = ents.Create("env_laser")
				l:SetKeyValue("lasertarget", tn)
				l:SetKeyValue("renderamt", "255")
				l:SetKeyValue("renderfx", "15")
				l:SetKeyValue("rendercolor", "150 150 200")
				l:SetKeyValue("texture", "sprites/laserbeam.spr")
				l:SetKeyValue("texturescroll", "35")
				l:SetKeyValue("dissolvetype", "1")
				l:SetKeyValue("spawnflags", "32")
				l:SetKeyValue("width", "15")
				l:SetKeyValue("damage", "50000")
				l:SetKeyValue("noiseamplitude", "10")
				l:Spawn()
				l:Fire("Kill", "", 1)
				l:Fire("turnoff", "", 0)
				l:Fire("turnon", "", 0)
				l:SetPos(tosmite:GetPos() + Vector(0, 0, 2000) + (VectorRand() * 100))
			end
			timer.Simple(1, function()
				if GetConVar("sbox_godmode"):GetInt() == 1 then
					tosmite:Kill()
				end
				local rd = tosmite:GetRagdollEntity()
				local t = "dissolve" .. rd:EntIndex()
				rd:SetKeyValue("targetname", t)
			
				local d = ents.Create("env_entity_dissolver")
				d:SetKeyValue("dissolvetype", math.random(0, 3))
				d:SetKeyValue("magnitude", 20)
				d:SetKeyValue("target", t)
				d:SetPos(tosmite:GetPos())
				d:Spawn()
				d:Fire("Dissolve", t, 0)
				d:Fire("kill", "", 5)
			end)
		end)
	end
end

lolbot:Register(CMD)
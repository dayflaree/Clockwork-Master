hook.Add("KeyPress", "AFK_KeyPress", function(ply, key)
	if ply.AFKNPC then ply.AFKNPC:Remove() end
	
	timer.Create("AFK_" .. ply:Nick(), 60 * 5, 1, function()
		local npc = ents.Create("npc_citizen")
		npc:SetPos(ply:GetPos())
		npc:SetAngles(ply:GetAngles())
		npc:SetModel(ply:GetModel())
		npc:Spawn()
		npc:Activate()
		npc:SetAnimation(ACT_IDLE_RELAXED)
		npc:CapabilitiesClear()
		npc:CapabilitiesAdd(CAP_ANIMATEDFACE | CAP_TURN_HEAD)
		for _,v in pairs(ents.GetAll()) do npc:AddEntityRelationship(v, D_LI, 99) end
		
	end)
end)
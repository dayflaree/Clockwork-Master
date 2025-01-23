concommand.Add("ents_export", function(ply, cmd, args)
	for k, ent in pairs(ents.FindByClass("prop_physics")) do
		MsgN('local ent = ents.Create("prop_physics")')
		MsgN('ent:SetModel("' .. ent:GetModel() .. '")')
		local pos = ent:GetPos()
		MsgN('ent:SetPos(Vector(' .. math.Round(pos.x) .. ', ' .. math.Round(pos.y) .. ', ' .. math.Round(pos.z) .. '))')
		local ang = ent:GetAngles()
		MsgN('ent:SetAngles(Angle(' .. math.Round(ang.p) .. ', ' .. math.Round(ang.y) .. ', ' .. math.Round(ang.r) .. '))')
		MsgN('')
	end
end)

concommand.Add("ent_export", function(ply, cmd, args)
	local ent = ply:GetEyeTrace().Entity
	MsgN('EntIndex: ' .. ent:EntIndex())
	MsgN('local ent = ents.Create("prop_physics")')
	local pos = ent:GetPos()
	MsgN('ent:SetPos(Vector(' .. math.Round(pos.x) .. ', ' .. math.Round(pos.y) .. ', ' .. math.Round(pos.z) .. '))')
	local ang = ent:GetAngles()
	MsgN('ent:SetAngles(Angle(' .. math.Round(ang.p) .. ', ' .. math.Round(ang.y) .. ', ' .. math.Round(ang.r) .. '))')
	MsgN('')
end)

concommand.Add("ent_pos", function(ply, cmd, args)
	local pos = ply:GetEyeTrace().HitPos
	MsgN(tostring(pos))
end)

concommand.Add("checkpoint", function(ply, cmd, args)
	local pos = ply:GetEyeTrace().HitPos
	
	MsgN('AddCheckpoint(Vector(' .. math.Round(pos.x) .. ', ' .. math.Round(pos.y) .. ', ' .. math.Round(pos.z) .. '))')
end)
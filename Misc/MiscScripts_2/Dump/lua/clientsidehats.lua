local clHats = {}

hook.Add("Think", "clHats_Think", function()
	for _, ply in pairs(player.GetAll()) do
		if not clHats[ply:EntIndex()] then
			clHats[ply:EntIndex()] = ClientsideModel("models/error.mdl")
			clHats[ply:EntIndex()]:SetNoDraw(true)
		end
	end
end)
 
hook.Add("PostPlayerDraw", "clHats_PostPlayerDraw", function(ply)
	if ply._Hat and clHats[ply:EntIndex()] then
		local _Hat = clHats[ply:EntIndex()]
		_Hat:SetModel(ply._Hat.Model)
		
		local pos, ang
		
		if ply._Hat.Attachment then
			local attach = ply:GetAttachment(ply:LookupAttachment(ply._Hat.Attachment))
			pos, ang = ply._Hat.Offset(ply, attach.Pos, attach.Ang)
		elseif ply._Hat.Bone then
			pos, ang = ply:GetBonePosition(ply:LookupBone(hat.Bone))
			pos, ang = ply._Hat.Offset(ply, pos, ang)
		else
			pos = ply:GetPos()
			ang = ply:GetAngles()
		end
		
		_Hat:SetPos(pos)
		_Hat:SetAngles(ang)
		_Hat:DrawModel()
	end
end)

-- lua_run_cl for k, ply in pairs(player.GetAll()) do ply._Hat = {Model = "models/Combine_Helicopter/helicopter_bomb01.mdl", Attachment = "eyes", Offset = function(ply, pos, ang) pos = pos + (ang:Forward() * -2) return pos, ang end} end
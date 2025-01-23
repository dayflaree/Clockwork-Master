local offsets = {
	gmod_tool = {
		Bone = "ValveBiped.Bip01_R_Thigh",
		Modify = function(pos, ang)
			pos = pos + (ang:Up() * -4)
			pos = pos + (ang:Right() * -3)
			ang:RotateAroundAxis(ang:Forward(), 100)
			return pos, ang
		end
	},
	weapon_physgun = {
		Bone = "ValveBiped.Bip01_Spine2",
		Modify = function(pos, ang)
			pos = pos + (ang:Forward() * 10)
			pos = pos + (ang:Right() * 7)
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 7)
			ang:RotateAroundAxis(ang:Up(), 180)
			return pos, ang
		end
	},
	weapon_pistol = {
		Bone = "ValveBiped.Bip01_L_Thigh",
		Modify = function(pos, ang)
			pos = pos + (ang:Up() * 4)
			pos = pos + (ang:Forward() * 7)
			ang:RotateAroundAxis(ang:Right(), 180)
			ang:RotateAroundAxis(ang:Forward(), 100)
			return pos, ang
		end
	}
	-- Add your own, should you wish.
}

local CLWeapons = {}

hook.Add("Think", "CLW_Think", function()
	for _, ply in pairs(player.GetAll()) do
		if not CLWeapons[ply] then CLWeapons[ply] = {} end
		
		for _, weap in pairs(ply:GetWeapons()) do
			if offsets[weap:GetClass()] then
				if not CLWeapons[ply][weap:GetClass()] then
					MsgN("Creating model " .. string.gsub(weap:GetModel(), "v_", "w_"))
					local model = ClientsideModel(string.gsub(weap:GetModel(), "v_", "w_")) -- GetModel called on yourself local weapon returns the viewmodel rather than world model.
					model:SetSkin(weap:GetSkin())
					model:SetNoDraw(true)
					CLWeapons[ply][weap:GetClass()] = model
				end
			end
		end
	end
end)

hook.Add("PostPlayerDraw", "CLW_PostPlayerDraw", function(ply)
	if not CLWeapons[ply] then return end
	
	for class, model in pairs(CLWeapons[ply]) do
		if offsets[class] then
			if class ~= ply:GetActiveWeapon():GetClass() then
				local pos, ang = ply:GetBonePosition(ply:LookupBone(offsets[class].Bone))
				pos, ang = offsets[class].Modify(pos, ang)
				
				model:SetPos(pos)
				model:SetAngles(ang)
				model:DrawModel()
			end
		end
	end
end)
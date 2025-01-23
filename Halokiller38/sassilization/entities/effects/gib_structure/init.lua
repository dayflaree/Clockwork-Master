function EFFECT:Init(data)
	local structure = data:GetEntity()
	local power = data:GetScale()
	local height = data:GetRadius()
	local type = math.Round(tonumber(data:GetMagnitude()))
	local pos
	if ValidEntity( structure ) and structure != NULL then
		pos = structure:GetPos()
	end
	if data:GetOrigin() then
		pos = data:GetOrigin()
	end

	if !pos then return end

	if type == GIB_STONE then
		for i=1, power do
			local effectdata = EffectData()
				effectdata:SetOrigin(pos + Vector(0,0,height) + VectorRand() * 4)
				effectdata:SetScale(math.random(1, #Gibs_Stone))
				effectdata:SetMagnitude( GIB_STONE )
			util.Effect("gib", effectdata)
		end
	elseif type > GIB_STONE then
		for i=1, power do
			local effectdata = EffectData()
				effectdata:SetOrigin(pos + Vector(0,0,height) + VectorRand() * 4)
				effectdata:SetScale(math.random(1, #Gibs_Wood))
				effectdata:SetMagnitude( GIB_WOOD )
			util.Effect("gib", effectdata)
		end
		if type == GIB_ALL then
			for i=1, power do
				local effectdata = EffectData()
					effectdata:SetOrigin(pos + Vector(0,0,height) + VectorRand() * 4)
					effectdata:SetScale(math.random(1, #Gibs_Stone))
					effectdata:SetMagnitude( GIB_STONE )
				util.Effect("gib", effectdata)
			end
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

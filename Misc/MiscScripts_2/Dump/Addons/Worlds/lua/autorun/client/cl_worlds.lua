surface.CreateFont("coolvetica", 100, 400, true, false, "WorldsToolFont")

// Entity extensions.
local Entity = FindMetaTable("Entity")

function Entity:GetWorld()
	return self:GetNWInt("world")
end

function Entity:Hide()
	self:SetNoDraw(true)
	if self.Hidden then return end
	self.SavedPos = self:GetPos()
	self:SetPos(Vector(0, 0, -5000))
	self.Hidden = true
end

function Entity:Show()
	self:SetNoDraw(false)
	if not self.Hidden then return end
	self.Hidden = false
	self:SetPos(self.SavedPos)
end

// Hooks
function Worlds()
	for _, ent in pairs(ents.GetAll()) do
		if ent:GetWorld() != LocalPlayer():GetWorld() and ent != LocalPlayer() and ent != LocalPlayer():GetViewModel() then
			ent:Hide()
		else
			ent:Show()
		end
	end
end
hook.Add("RenderScene", "WorldsRenderScene", Worlds)

function PlayerChangedWorld(ply, world, oldworld)
	for k, ent in pairs(ents.GetAll()) do
		if ent:GetWorld() == oldworld or ent:GetWorld() == world then
			local ed = EffectData()
				ed:SetEntity(ent)
			util.Effect("entity_remove", ed, true, true)
		end
	end
end
hook.Add("PlayerChangedWorld", "Worlds", PlayerChangedWorld)
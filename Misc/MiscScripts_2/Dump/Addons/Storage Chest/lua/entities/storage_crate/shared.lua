ENT.Type	   		= "anim"
ENT.Base	   		= "base_anim"
ENT.PrintName	  	= "Storage Crate"
ENT.Author			= "_Undefined"
ENT.Contact  		= "admin@equinox-studios.com"
ENT.Purpose  		= "Stores your stuff!"
ENT.Instructions	= "Touch to store and E to restore!"
ENT.Spawnable	  	= true
ENT.AdminSpawnable  = true
ENT.AutomaticFrameAdvance = true

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	
	ply.storage_chest = ent
	
	return ent
end

function ENT:Initialize()
	if not SERVER then return end
	
	self:SetModel("models/Items/ammocrate_ar2.mdl")
	self:SetUseType(SIMPLE_USE)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.Open = true
end

function ENT:Touch(ent)
	if CPPI and not ent:CPPIGetOwner() == self:CPPIGetOwner() then return end
end

function ENT:Use(activator, caller)
	if not activator:IsValid() or not activator:IsPlayer() then return end
	
	if self.Open then
		self:SetSequence(self:LookupSequence("Close"))
		self.Open = false
		
		datastream.StreamToClients(activator, "storage_chest", { Show = true, Items = {self.Items} })
	else
		self:SetSequence(self:LookupSequence("Open"))
		self.Open = true
		
		datastream.StreamToClients(activator, "storage_chest", { Show = false })
	end
end

function ENT:Draw()
	self:DrawModel()
	
	if CPPI and not self.ply then
		self.ply = self:CPPIGetOwner()
	end
	
	if self.ply and self.ply:IsValid() then
		local pos = self:GetPos() + (self:GetUp() * -10) + (self:GetForward() * 16)
		local ang = self:GetAngles()
		
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)
		
		cam.Start3D2D(pos, ang, 0.1)
			draw.SimpleText(self.ply:Nick() .. "'s Storage Crate", "HUDNumber2", 0, 0, team.GetColor(self.ply:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
	
	local pos = self:GetPos() + (self:GetUp() * -16)
	local ang = self:GetAngles()
	
	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(30, 28, 18, 255)
		surface.DrawRect(-155, -275, 310, 550)
	cam.End3D2D()
	
	local pos = self:GetPos() + (self:GetUp() * 3)
	
	ang:RotateAroundAxis(ang:Right(), 180)
	
	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(30, 28, 18, 255)
		surface.DrawRect(-155, -275, 310, 550)
	cam.End3D2D()
end

datastream.Hook("storage_chest", function(handler, id, encoded, decoded)
	if decoded.Show then
		sc_gui = vgui.Create("DFrame")
		sc_gui:SetSize(660, 760)
		sc_gui:SetTitle("Storage Crate!")
		sc_gui:SetVisible(true)
		sc_gui:SetDraggable(true)
		sc_gui:ShowCloseButton(true)
		sc_gui:MakePopup()
		sc_gui:Center()
		sc_gui:SizeToContents()
		
		--[[ local Items = vgui.Create("DPanelList", sc_gui)
		Items:SetPos(5, 25)
		Items:SetSize(Tabs:GetWide() - 10, Tabs:GetTall() - 30)
		Items:SetSpacing(5)
		Items:SetPadding(5)
		Items:EnableHorizontal(true)
		Items:EnableVerticalScrollbar(false)
		
		for k, v in pairs(decoded.Items) do
			local Icon = vgui.Create("SpawnIcon")
			Icon:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
			Items:AddItem(Icon)
		end ]]
	else
		if sc_gui then
			sc_gui:Remove()
		end
	end
end)
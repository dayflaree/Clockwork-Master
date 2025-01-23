TOOL.Category = "Construction"
TOOL.Name = "#Barbed Wire"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.Stored = true

TOOL.StartPos = false
TOOL.EndPos = false

if CLIENT then
	language.Add("Tool_barbedwire_name", "Barbed Wire")
	language.Add("Tool_barbedwire_desc", "Place barbed wire to keep people out!")
	language.Add("Tool_barbedwire_0", "Left click to start a fence")
	language.Add("Tool_barbedwire_1", "Left click to end the current fence")
	
	language.Add("Undone_barbedwire", "Undone Barbed Wire")
end

cleanup.Register("barbedwire")

function TOOL:LeftClick(tr)
	if not self.StartPos and tr.Hit then self.StartPos = tr.HitPos self:SetStage(1) return true end
	
	if self.StartPos then
		self.EndPos = tr.HitPos
		
		local num = math.Round(self.StartPos:Distance(self.EndPos) / 100)
		
		local ang = (self.StartPos - self.EndPos):Angle()
		
		self.StartPos = self.StartPos + (self.EndPos - self.StartPos):GetNormal() * -52
		
		undo.Create("barbedwire")
		
		local levels = self:GetClientNumber("levels", 1)
		
		for i = 1, num do
			local n = self.StartPos + (self.EndPos - self.StartPos):GetNormal() * 100
			
			local p = ents.Create("barbed_wire")
			p:SetPos(n)
			p:SetAngles(ang)
			p:Spawn()
			
			self.StartPos = n
			
			undo.AddEntity(p)
		end
		
		undo.SetPlayer(self:GetOwner())
		undo.Finish()
		
		self:SetStage(0)
		self:ResetPositions()
	end
	
	return true
end

function TOOL:RightClick(tr)
	
end

function TOOL:Think()
	
end

function TOOL:ResetPositions()
	self.StartPos = false
	self.EndPos = false
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", { Text = "#Tool_barbedwire_name", Description	= "#Tool_barbedwire_desc" })
	CPanel:AddControl("Slider", { Label = "Levels", Description = "The number of levels of barbed wire to place.", Command = "Barbedwire_levels", Type = "Integer", min = 1, max = 10 })
end
ENT.Base = "base_ai" 
ENT.Type = "ai"
 
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""  //fill in these if you want it to be in the spawn menu
ENT.Purpose			= ""
ENT.Instructions	= ""
 
ENT.AutomaticFrameAdvance = true
 
function ENT:OnRemove()
	
end
 
function ENT:PhysicsCollide(data, physobj)
	
end
 
function ENT:PhysicsUpdate(physobj)
	
end
 
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
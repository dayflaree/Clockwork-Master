include( "shared.lua" )

function ENT:Draw()
	self.Entity:DrawShadow( false )
    self.Entity:DrawModel()
end
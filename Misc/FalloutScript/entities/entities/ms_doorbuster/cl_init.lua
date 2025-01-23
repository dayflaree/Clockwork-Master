include('shared.lua')

function ENT:Initialize()

end

function ENT:Draw()
self.BaseClass.Draw(self)
if ( LocalPlayer():GetEyeTrace().Entity == self.Entity  and  EyePos():Distance( self.Entity:GetPos() ) < 512 ) then
	active=self.Entity:GetNetworkedBool("active")
	local string="Door buster"
AddWorldTip(self.Entity:EntIndex(),string,0.5,self.Entity:GetPos(),self.Entity)
end
end

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:Touch()
end
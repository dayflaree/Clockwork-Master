include("shared.lua");

function ENT:Draw()
	if (RP.Plugin:Call("EntityDraw", self) != false) then
		self:DrawModel();
	end;
end;
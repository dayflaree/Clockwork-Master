include("shared.lua");

function ENT:Draw()
	if (RP:ItemEntityDraw(self) != false) then
		self:DrawModel();
	end;
end;
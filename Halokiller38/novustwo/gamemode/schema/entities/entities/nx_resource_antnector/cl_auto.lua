--[[
Name: "cl_auto.lua".
Product: "FalloutRP".
--]]

NEXUS:IncludePrefixed("sh_auto.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = NEXUS.schema.GetColor("target_id");
	local colorWhite = NEXUS.schema.GetColor("white");
	
	y = NEXUS:DrawInfo("Anthill Resource", x, y, colorTargetID, alpha);
	
	if (NEXUS.Client:GetPos():Distance( self:GetPos() ) <= 80) then
		y = NEXUS:DrawInfo("Press E to harvest.", x, y, colorWhite, alpha);
	else
		y = NEXUS:DrawInfo("A harvestable object.", x, y, colorWhite, alpha);
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	//SCHEMA:NexusGeneratorEntityDraw( self, Color(255, 0, 0, 5) );
	self:DrawModel();
end;
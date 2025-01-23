
ITEM.Name = "Morphine";

ITEM.Description = "This should take away the pain.."; 
ITEM.Model = "models/healthvial.mdl"
ITEM.CamPos = Vector( 80, 0, 0 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 10;

ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 30;

ITEM.Flags = "u";

function ITEM:Use()

	self.Owner:GiveHealth( 10 );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + 10, 0, 100 ) );

end
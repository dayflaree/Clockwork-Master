
ITEM.Name = "Horse Meat";

ITEM.Description = "God help us if Horsey finds out about this..."; 
ITEM.Model = "models/props_junk/cardboard_box004a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 12;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 5;

ITEM.Flags = "e";

function ITEM:Use()

	self.Owner:GiveHealth( 10 );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + 10, 0, 100 ) );

end
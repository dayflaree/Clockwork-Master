
ITEM.Name = "Rat Meat";

ITEM.Description = "Looks raw so I'll need to cook this first, I wounder if it'll taste like beef."; 
ITEM.Model = "models/props_junk/cardboard_box004a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 12;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 3;

ITEM.Flags = "e";

function ITEM:Use()

	self.Owner:GiveHealth( 14 );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + 12, 0, 100 ) );

end

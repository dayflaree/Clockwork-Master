
ITEM.Name = "Sache of Rice";

ITEM.Description = "A sache of rice. I could boil or fry this."; 
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 8;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 8;

ITEM.Flags = "e";

function ITEM:Use()

	self.Owner:GiveHealth( 12 );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + 15, 0, 100 ) );

end
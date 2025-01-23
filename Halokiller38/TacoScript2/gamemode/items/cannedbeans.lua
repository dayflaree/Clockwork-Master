
ITEM.Name = "Can of Beans";

ITEM.Description = "An old rusty can of baked beans, they smell good."; 
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 5;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 12;

ITEM.Flags = "e";

function ITEM:Use()

	self.Owner:GiveHealth( 6 );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + 13, 0, 100 ) );

end
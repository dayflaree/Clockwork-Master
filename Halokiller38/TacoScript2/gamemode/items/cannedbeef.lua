
ITEM.Name = "Canned Beef";

ITEM.Description = "An old can of corn beef, tuck in, mate."; 
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 5;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 15;

ITEM.Flags = "e";

function ITEM:Use()

	self.Owner:GiveHealth( 10 );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + 15, 0, 100 ) );

end

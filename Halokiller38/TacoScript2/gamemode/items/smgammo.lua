
ITEM.Name = "SMG Ammo";

ITEM.Description = "A container full of SMG rounds x30"; 
ITEM.Model = "models/Items/BoxMRounds.mdl"

ITEM.CamPos = Vector( 49, 48, 33 ) 
ITEM.LookAt = Vector( 0, 0, 7 ) 
ITEM.FOV = 24

ITEM.Width = 2;
ITEM.Height = 2;

ITEM.Price = 175;

ITEM.Flags = "u";

function ITEM:Use()

	self.Owner:GiveAmmo( 30, "smg1" );

end
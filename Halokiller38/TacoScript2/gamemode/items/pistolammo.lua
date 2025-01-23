
ITEM.Name = "Pistol Ammo";

ITEM.Description = "A container full of 9mm pistol rounds x30"; 
ITEM.Model = "models/Items/BoxSRounds.mdl"

ITEM.CamPos = Vector( 112, -4, 7 ) 
ITEM.LookAt = Vector( 2, 0, 6 ) 
ITEM.FOV = 9

ITEM.Width = 2;
ITEM.Height = 1;

ITEM.Price = 175;

ITEM.Flags = "u";

function ITEM:Use()

	self.Owner:GiveAmmo( 30, "pistol" );
	
end
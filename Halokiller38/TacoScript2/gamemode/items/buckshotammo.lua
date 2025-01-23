
ITEM.Name = "Shotgun Ammo";

ITEM.Description = "A small box of buckshot rounds x20"; 
ITEM.Model = "models/Items/BoxBuckshot.mdl"

ITEM.CamPos = Vector( 50, 50, 50 ) 
ITEM.LookAt = Vector( 0, 0, 5 ) 
ITEM.FOV = 13

ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 175;

ITEM.Flags = "u";

function ITEM:Use()

	self.Owner:GiveAmmo( 20, "buckshot" );

end
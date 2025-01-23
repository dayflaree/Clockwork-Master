ITEM.Name = "Flashlight";

ITEM.Description = "Light up dark alleyways and fend yourself from rapists with this."; 

ITEM.Model = "models/items/ar2_grenade.mdl"
ITEM.CamPos = Vector( -89, 80, 62 ) 
ITEM.LookAt = Vector( 5, -5, -3 ) 
ITEM.FOV = 3

ITEM.Price = 75;

ITEM.Width = 2;
ITEM.Height = 1;


function ITEM:Drop()

	self.Owner:Flashlight( false );

end
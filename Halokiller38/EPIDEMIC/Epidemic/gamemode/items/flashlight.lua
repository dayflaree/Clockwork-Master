ITEM.Name = "Flashlight";

ITEM.Description = "Light up dark alleyways and fend yourself from rapists with this."; 

ITEM.Model = "models/kamern/flashlight.mdl"
ITEM.CamPos = Vector( 88, 186, 200 )
ITEM.LookAt = Vector( -96, -200, -200 )
ITEM.FOV = 4
ITEM.Flags = "x"
ITEM.Width = 2;
ITEM.Height = 1;
ITEM.NicePhrase = "a flashlight";

ITEM.Tier = 2;

function ITEM:Drop()

	self.Owner:Flashlight( false );

end


function ITEM:Examine()

	self.Owner:NoticePlainWhite( "It's a flashlight with working batteries." );

end

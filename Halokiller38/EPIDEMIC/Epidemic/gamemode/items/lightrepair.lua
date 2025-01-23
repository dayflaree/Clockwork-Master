
ITEM.Name = "Light Weapon Repair Kit";
ITEM.NicePhrase = "repair kit";
ITEM.Description = "Useful tools to help you repair a broken weapon."; 
ITEM.Model = "models/props/CS_militia/reloadingpress01.mdl"
ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 5 ); 
ITEM.FOV = 23;
ITEM.Width = 2;
ITEM.Height = 2;
ITEM.Flags = "gx";

ITEM.Tier = 4;

ITEM.LightWeight = true;
ITEM.Amt = 60;

function ITEM:Examine()

	self.Owner:NoticePlainWhite( "It's never been used." );

end


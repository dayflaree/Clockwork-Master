ITEM.Name = "Binoculars";

ITEM.Description = "Can't see that spec over there? Here, use this."; 

ITEM.Model = "models/Items/battery.mdl"
ITEM.CamPos = Vector( -35, -54, 24 ) 
ITEM.LookAt = Vector( 0, 0, 5 ) 
ITEM.FOV = 14
ITEM.Flags = "x"
ITEM.Width = 2;
ITEM.Height = 1;
ITEM.NicePhrase = "a pair of binoculars";

ITEM.Tier = 3;

function ITEM:Pickup()
	
	self.Owner:SetCanZoom( true );
	
end

function ITEM:Drop()

	self.Owner:SetCanZoom( false );

end


function ITEM:Examine()

	self.Owner:NoticePlainWhite( "Military grade." );

end


ITEM.Name = "Beans";
ITEM.NicePhrase = "a can of beans";
ITEM.Description = "Some hearty protein"; 
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 5;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ex";

ITEM.AddsOn = true;
ITEM.AddOnMax = 2;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 5, 12 ) );
	
	return true;

end

function ITEM:Examine()

	self.Owner:NoticePlainWhite( "Still has it's lid on, luckily." );

end

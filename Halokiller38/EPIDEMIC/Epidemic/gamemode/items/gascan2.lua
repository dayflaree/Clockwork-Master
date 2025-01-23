ITEM.Name = "Gas Can";
ITEM.NicePhrase = "A Metal Gas Can";
ITEM.Description = "Lid Shut Tight"; 
ITEM.Model = "models/props_junk/metalgascan.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 5;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "x";

ITEM.AddsOn = false;
ITEM.AddOnMax = 3;

ITEM.Tier = 1;

function ITEM:Examine()
	
	local n = math.random( 1, 3 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "Heavy." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "Swishes when moved quickly." );
		
	else
		
		self.Owner:NoticePlainWhite( "Fun for fires." );
		
	end

end
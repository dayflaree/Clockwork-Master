ITEM.Name = "Gas Can";
ITEM.NicePhrase = "A Gas Can";
ITEM.Description = "Lid on tight"; 
ITEM.Model = "models/props_junk/gascan001a.mdl"
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
		
		self.Owner:NoticePlainWhite( "Smells like gas." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "Feels oily." );
		
	else
		
		self.Owner:NoticePlainWhite( "This can be very useful in these times." );
		
	end

end
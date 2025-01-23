ITEM.Name = "doll";
ITEM.NicePhrase = "A small baby doll";
ITEM.Description = "Missing a eye"; 
ITEM.Model = "models/props_c17/doll01.mdl"
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
		
		self.Owner:NoticePlainWhite( "Kind of creepy." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "The doll is filthy." );
		
	else
		
		self.Owner:NoticePlainWhite( "It looks like some cheap doll made in china." );
		
	end

end

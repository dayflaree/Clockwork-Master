ITEM.Name = "Coffee Mug";
ITEM.NicePhrase = "A Coffee Mug";
ITEM.Description = "A Small Crack At The Top"; 
ITEM.Model = "models/props/cs_office/coffee_mug3.mdl"
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
		
		self.Owner:NoticePlainWhite( "Very Holdable." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "The mug has nice curves." );
		
	else
		
		self.Owner:NoticePlainWhite( "It looks like some cheap mug made in china." );
		
	end

end
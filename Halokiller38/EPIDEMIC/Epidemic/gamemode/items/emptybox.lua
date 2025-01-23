ITEM.Name = "Empty Box";
ITEM.NicePhrase = "A Empty Box";
ITEM.Description = "Use to be occupied by some kind of treat"; 
ITEM.Model = "models/props_lab/box01b.mdl"
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
		
		self.Owner:NoticePlainWhite( "Empty with crumbs at the bottom." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "Someone or thing got to this first." );
		
	else
		
		self.Owner:NoticePlainWhite( "Looks like it was tasty." );
		
	end

end
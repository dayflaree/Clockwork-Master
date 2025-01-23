 ITEM.Name = "Silver Fish";
ITEM.NicePhrase = "A small plastic toy fish";
ITEM.Description = "Made of Plastic"; 
ITEM.Model = "models/props/CS_militia/fishriver01.mdl"
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

self.Owner:NoticePlainWhite( "Not edible.");

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "No, this doesn't mean you can fish." );

else

self.Owner:NoticePlainWhite( "Floats, but doesn't swim." );

end

end

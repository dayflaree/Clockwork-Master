ITEM.Name = "Shoe";
ITEM.NicePhrase = "A used boot";
ITEM.Description = "Torn up"; 
ITEM.Model = "models/props_junk/Shoe001a.mdl"
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

self.Owner:NoticePlainWhite( "Don't put it on your head.");

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Not exactly useful anymore." );

else

self.Owner:NoticePlainWhite( "Hole in the bottom of it..." );

end

end

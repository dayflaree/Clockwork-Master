ITEM.Name = "Phone Handle";
ITEM.NicePhrase = "Not too terribly useful without the base";
ITEM.Description = "Missing a wire"; 
ITEM.Model = "models/props/de_prodigy/desk_console1b.mdl"
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

self.Owner:NoticePlainWhite( "Missing the base..." );

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Doesn't actually connect to anything." );

else

self.Owner:NoticePlainWhite( "Missing some wiring." );

end

end

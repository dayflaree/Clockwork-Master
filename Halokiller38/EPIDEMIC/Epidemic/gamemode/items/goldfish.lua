ITEM.Name = "Gold Fish";
ITEM.NicePhrase = "A small toy fish";
ITEM.Description = "Made of Plastic"; 
ITEM.Model = "models/props/de_inferno/GoldFish.mdl"
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

self.Owner:NoticePlainWhite( "Looks bent...");

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Floats, but doesn't swim." );

else

self.Owner:NoticePlainWhite( "Doesn't smile back." );

end

end

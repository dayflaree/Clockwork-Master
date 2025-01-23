ITEM.Name = "Money Wad";
ITEM.NicePhrase = "100 US Dollars";
ITEM.Description = "Money"; 
ITEM.Model = "models/props/cs_assault/Money.mdl"
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

self.Owner:NoticePlainWhite( "Some are slightly torn...");

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Loads of money!" );

else

self.Owner:NoticePlainWhite( "Don't keep it in your pocket." );

end

end

ITEM.Name = "One Dollar";
ITEM.NicePhrase = "1 US Dollar";
ITEM.Description = "Money"; 
ITEM.Model = "models/props/cs_assault/Dollar.mdl"
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

self.Owner:NoticePlainWhite( "Currency of the United States.");

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Slightly crumpled up..." );

else

self.Owner:NoticePlainWhite( "Not made of paper..." );

end

end

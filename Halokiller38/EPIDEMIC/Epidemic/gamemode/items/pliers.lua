ITEM.Name = "pliers";
ITEM.NicePhrase = "A pair of Pliers";
ITEM.Description = "Useful for grabbing things"; 
ITEM.Model = "models/props_c17/tools_pliers01a.mdl"
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

self.Owner:NoticePlainWhite( "Could be useful..." );

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Slightly rusty." );

else

self.Owner:NoticePlainWhite( "Grab stuff with it." );

end

end

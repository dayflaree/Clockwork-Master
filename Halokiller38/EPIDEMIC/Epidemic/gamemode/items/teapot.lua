ITEM.Name = "Tea Pot";
ITEM.NicePhrase = "A Tea pot";
ITEM.Description = "Slightly rusted"; 
ITEM.Model = "models/props_interiors/pot01a.mdl"
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

self.Owner:NoticePlainWhite( "Dented.");

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "For boiling things." );

else

self.Owner:NoticePlainWhite( "Earl Grey not included." );

end

end


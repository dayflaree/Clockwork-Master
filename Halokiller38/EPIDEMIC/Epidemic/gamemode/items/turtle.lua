ITEM.Name = "Turtle";
ITEM.NicePhrase = "A small stuffed turtle";
ITEM.Description = "A young Childs toy"; 
ITEM.Model = "models/props/de_tides/Vending_turtle.mdl"
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

self.Owner:NoticePlainWhite( "It's missing some stuffing." );

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Hat not included." );

else

self.Owner:NoticePlainWhite( "Looks cute..." );

end

end

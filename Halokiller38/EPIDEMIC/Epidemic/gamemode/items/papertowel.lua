ITEM.Name = "Paper Towel";
ITEM.NicePhrase = "A roll of paper towels";
ITEM.Description = "Not exactly clean"; 
ITEM.Model = "models/props/cs_office/Paper_towels.mdl"
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

self.Owner:NoticePlainWhite( "Still has most on there.");

elseif( n == 2 ) then

self.Owner:NoticePlainWhite( "Sanitation is needed, especially with zombies around." );

else

self.Owner:NoticePlainWhite( "Not exactly white anymore." );

end

end

ITEM.Name = "Two-Way Radio";

ITEM.Description = "Communicate with others on the same channel"; 

ITEM.Model = "models/deadbodies/dead_male_civilian_radio.mdl"
ITEM.CamPos = Vector( 50, 50, 50 ) 
ITEM.LookAt = Vector( -3, 0, 9 ) 
ITEM.FOV = 10
ITEM.Flags = "rx"
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.NicePhrase = "a two-way radio";

ITEM.Tier = 2;

function ITEM:Examine()
	
	local n = math.random( 1, 2 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "Batteries are luckily still inside." );
		
	else
		
		self.Owner:NoticePlainWhite( "Suprisingly seems to work." );
		
	end

end

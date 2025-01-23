
ITEM.Name = "Chinese Takeout";
ITEM.NicePhrase = "a carton of chinese takeout";
ITEM.Description = "Courtesy of General Tso."; 
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 14;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ex";

ITEM.AddsOn = true;
ITEM.AddOnMax = 3;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 4, 9 ) );
	
	return true;

end

function ITEM:Examine()
	
	local n = math.random( 1, 3 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "The noodles are hard and cold." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "A reciept is attached - bought sometime in July of 2012." );
		
	else
		
		self.Owner:NoticePlainWhite( "Already opened." );
		
	end

end

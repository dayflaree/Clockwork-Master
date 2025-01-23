
ITEM.Name = "Tuna";
ITEM.NicePhrase = "a can of tuna";
ITEM.Description = "Human catfood"; 
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 5;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ex";

ITEM.AddsOn = true;
ITEM.AddOnMax = 3;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 2, 5 ) );
	
	return true;

end

function ITEM:Examine()
	
	local n = math.random( 1, 3 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "Luckily, the lid is still attached." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "The tin is filthy." );
		
	else
		
		self.Owner:NoticePlainWhite( "It looks like some animal - or zombie - tried to get in." );
		
	end

end

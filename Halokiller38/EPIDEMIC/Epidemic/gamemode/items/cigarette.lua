
ITEM.Name = "Cigarette";
ITEM.NicePhrase = "a single cigarette";
ITEM.Description = "Might be usable as currency at some point."; 
ITEM.Model = "models/phycignew.mdl"
ITEM.CamPos = Vector( 50, 50, 76 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 3;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "sx";

ITEM.AddsOn = true;
ITEM.AddOnMax = 80;

ITEM.Tier = 2;

function ITEM:Use()
	
	self.Owner:AttachCig();
	return true;

end

function ITEM:Examine()
	
	local n = math.random( 1, 3 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "It's fairly old." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "They said this would be the death of us. They said." );
		
	elseif( n == 3 ) then
		
		self.Owner:NoticePlainWhite( "A plain Shibboro cigarette." );
		
	end

end


ITEM.Name = "Jello";
ITEM.NicePhrase = "a can of jello";
ITEM.Description = "Tasty jello"; 
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 5;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ex";
ITEM.Amount = 12;

ITEM.Tier = 1;

ITEM.AddsOn = true;
ITEM.AddOnMax = 24;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 1, 4 ) );
	
	self.Amount = self.Amount - 1;

	if( self.InInventory ) then

		self.Owner:UpdateItemAmount( self.InvID, self.InvX, self.InvY );
	
	end
	
	if( self.Amount < 1 ) then
	
		return true;
	
	end
	
	return false;

end

function ITEM:Examine()
	
	local n = math.random( 1, 3 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "Lime-flavoured." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "Suprisingly well preserved." );
		
	else
		
		self.Owner:NoticePlainWhite( "Could possibly be used as currency." );
		
	end

end

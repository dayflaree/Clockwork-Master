ITEM.Name = "Orange";
ITEM.NicePhrase = "an orange";
ITEM.Description = "Nothing like some tongue pinching citric acid."; 
ITEM.Model = "models/props/cs_italy/orange.mdl"

ITEM.CamPos = Vector( 50, 50, 50 )
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 9;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "ex";
ITEM.Amount = 4;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 5, 12 ) );
	
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

	self.Owner:NoticePlainWhite( "Well past its prime, more grey than orange." );

end
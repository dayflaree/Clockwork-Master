ITEM.Name = "Chex Mix";
ITEM.NicePhrase = "a bag of chex mix";
ITEM.Description = "Some... well, sort of delicious, chex mix."; 
ITEM.Model = "models/props_junk/garbage_bag001a.mdl"

ITEM.CamPos = Vector( 50, 50, 46 )
ITEM.LookAt = Vector( 1, 0, 0 ); 
ITEM.FOV = 19;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "ex";
ITEM.Amount = 12;

ITEM.AddsOn = true;
ITEM.AddOnMax = 36;

ITEM.Tier = 1;

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

	self.Owner:NoticePlainWhite( "A few tiny tears, but fairly intact." );

end
ITEM.Name = "Pickles";
ITEM.NicePhrase = "jar of pickles";
ITEM.Description = "Cucumbers."; 
ITEM.Model = "models/props_lab/jar01b.mdl"

ITEM.CamPos = Vector( 50, -50, 50 ) 
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 11;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "ex";
ITEM.Amount = 8;

ITEM.AddsOn = true;
ITEM.AddOnMax = 12;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 5, 7 ) );
	
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
	
	if( math.random( 1, 2 ) == 1 ) then
		
		self.Owner:NoticePlainWhite( "Kosher dill pickles." );
		
	else
		
		self.Owner:NoticePlainWhite( "The label is peeling." );
		
	end

end

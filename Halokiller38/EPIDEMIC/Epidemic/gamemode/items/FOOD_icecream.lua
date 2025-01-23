ITEM.Name = "Ice Cream";
ITEM.NicePhrase = "ice cream";
ITEM.Description = "I wonder if it's still frozen."; 
ITEM.Model = "models/props_lab/box01a.mdl"

ITEM.CamPos = Vector( 50, 50, 50 ) 
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 11;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "ex";
ITEM.Amount = 3;

ITEM.AddsOn = true;
ITEM.AddOnMax = 12;

ITEM.Tier = 1;

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

	self.Owner:NoticePlainWhite( "Totally melted (what did you expect?)." );

end

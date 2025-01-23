ITEM.Name = "Box of Twinkies";
ITEM.NicePhrase = "a box of twinkies";
ITEM.Description = "Turns out these things COULD really survive an apocalypse."; 
ITEM.Model = "models/props_lab/box01a.mdl"

ITEM.CamPos = Vector( 27, 50, 26 )
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 13;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "ex";
ITEM.Amount = 6;

ITEM.AddsOn = true;
ITEM.AddOnMax = 12;

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
	
	if( math.random( 1, 2 ) == 1 ) then
		
		self.Owner:NoticePlainWhite( "Full of tears and dents." );
		
	else
		
		self.Owner:NoticePlainWhite( "Damp and warm." );
		
	end

end
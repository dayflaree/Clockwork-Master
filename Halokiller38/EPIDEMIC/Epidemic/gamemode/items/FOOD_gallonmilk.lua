
ITEM.Name = "Milk";
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Model = "models/props_junk/garbage_milkcarton001a.mdl"
ITEM.Description = "Expired today.";
ITEM.NicePhrase = "a gallon of milk";

ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 17;

ITEM.Flags = "dx";

ITEM.AddsOn = true;
ITEM.AddOnMax = 28;

ITEM.Amount = 14;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 4, 7 ) );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + math.random( 4, 8 ), 0, 100 ) );
	
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
		
		self.Owner:NoticePlainWhite( "Guaranteed to be sour." );
		
	else
		
		self.Owner:NoticePlainWhite( "A couple small dents on the outside." );
		
	end

end

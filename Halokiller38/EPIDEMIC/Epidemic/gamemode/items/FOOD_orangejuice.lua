
ITEM.Name = "Orange Juice";
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Model = "models/props_junk/garbage_milkcarton001a.mdl"
ITEM.Description = "The freshest oranges in the USA.";
ITEM.NicePhrase = "a gallon of orange juice";

ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 17;

ITEM.Flags = "dx";

ITEM.Amount = 14;

ITEM.AddsOn = true;
ITEM.AddOnMax = 28;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 5, 8 ) );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + math.random( 5, 9 ), 0, 100 ) );
	
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
		
		self.Owner:NoticePlainWhite( "The pulp and the juice have seperated." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "Apparently it has pulp." );
		
	else
		
		self.Owner:NoticePlainWhite( "Beat up carton." );
		
	end

end

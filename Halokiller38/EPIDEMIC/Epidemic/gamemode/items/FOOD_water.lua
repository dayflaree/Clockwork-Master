ITEM.Name = "Water Bottle";
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Model = "models/props/cs_office/Water_bottle.mdl";
ITEM.Description = "Water bottle";
ITEM.NicePhrase = "a bottle of water";

ITEM.CamPos = Vector( 50, -58, -13 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 16;

ITEM.Flags = "dx";

ITEM.Amount = 10;

ITEM.AddsOn = true;
ITEM.AddOnMax = 50;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + math.random( 2, 7 ), 0, 100 ) );
	
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
	
	local n = math.random( 1, 2 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "The lid is on." );
		
	else
		
		self.Owner:NoticePlainWhite( "Caked with dust." );
		
	end

end

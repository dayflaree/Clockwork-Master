ITEM.Name = "Vegetal Delight";
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.Description = "A thick mix mostly made up of vegetables.";
ITEM.NicePhrase = "a veggie drink";

ITEM.CamPos = Vector( 50, 39, 45 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 25;

ITEM.Flags = "dx";

ITEM.Amount = 12;

ITEM.AddsOn = true;
ITEM.AddOnMax = 30;

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
		
		self.Owner:NoticePlainWhite( "The cap is still tightly attached." );
		
	else
		
		self.Owner:NoticePlainWhite( "Room temperture." );
		
	end

end

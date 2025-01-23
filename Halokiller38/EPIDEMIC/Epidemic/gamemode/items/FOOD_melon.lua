ITEM.Name = "Melon";
ITEM.Width = 3;
ITEM.Height = 3;
ITEM.Model = "models/props_junk/watermelon01.mdl";
ITEM.Description = "Watermelon";
ITEM.NicePhrase = "a melon";

ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, -1 );
ITEM.FOV = 16;

ITEM.Flags = "ex";
ITEM.Amount = 12;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 1, 4 ) );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + math.random( 1, 4 ), 0, 100 ) );
	
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
		
		self.Owner:NoticePlainWhite( "Fairly intact." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "A couple fly-infested holes." );
		
	else
		
		self.Owner:NoticePlainWhite( "A dirty green shade." );
		
	end

end

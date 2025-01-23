
ITEM.Name = "Milk";
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Model = "models/props_junk/garbage_milkcarton002a.mdl"
ITEM.Description = "Sour. Like, bitter, it's turned half solid sour.";
ITEM.NicePhrase = "a quart of milk";

ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 16;

ITEM.Flags = "dx";

ITEM.Amount = 8;

ITEM.AddsOn = true;
ITEM.AddOnMax = 16;

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
	
	local n = math.random( 1, 3 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "Definately sour." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "1% fat." );
		
	else
		
		self.Owner:NoticePlainWhite( "It's half full." );
		
	end

end

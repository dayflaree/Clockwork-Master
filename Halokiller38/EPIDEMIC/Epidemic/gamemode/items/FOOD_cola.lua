
ITEM.Name = "Cola";
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Model = "models/props_junk/popcan01a.mdl"
ITEM.Description = "Carbonated beverage";
ITEM.NicePhrase = "a can of cola";

ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 8;

ITEM.Flags = "dx";

ITEM.Amount = 10;

ITEM.AddsOn = true;
ITEM.AddOnMax = 15;

ITEM.Tier = 1;

function ITEM:Use()

	self.Owner:GiveHealth( math.random( 1, 2 ) );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + math.random( 1, 3 ), 0, 100 ) );
	
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
		
		self.Owner:NoticePlainWhite( "Warm." );
		
	else
		
		self.Owner:NoticePlainWhite( "Flat." );
		
	end

end

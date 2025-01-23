ITEM.Name = "Pack of Cigarettes";
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Model = "models/boxopenshib.mdl"
ITEM.Description = "If it's used as currency, you're rich.";
ITEM.NicePhrase = "a single cigarette";

ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 5;

ITEM.Flags = "sx";

ITEM.Amount = 10;

ITEM.AddsOn = true;
ITEM.AddOnMax = 800;

ITEM.Tier = 3;

function ITEM:Use()

	self.Owner:AttachCig();
	
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
		
		self.Owner:NoticePlainWhite( "It's fairly old." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "They said this would be the death of us. They said." );
		
	elseif( n == 3 ) then
		
		self.Owner:NoticePlainWhite( "Plain Shibboro cigarettes." );
		
	end

end

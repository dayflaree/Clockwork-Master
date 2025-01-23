ITEM.Name = "Military Ration";
ITEM.NicePhrase = "a military ration";
ITEM.Description = "Contains: A plastic spork, chicken strips, rye crisp crackers, two water pouches, and five shortbread cookies."; 
ITEM.Model = "models/weapons/w_package.mdl"

ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 7, -2, 0 ); 
ITEM.FOV = 20;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "ex";
ITEM.Amount = 5;

ITEM.AddsOn = true;
ITEM.AddOnMax = 15;

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

	self.Owner:NoticePlainWhite( "Clear of any tears or markings." );

end
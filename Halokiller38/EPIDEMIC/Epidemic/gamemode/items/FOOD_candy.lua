ITEM.Name = "Box of Candy";
ITEM.NicePhrase = "A nice box of Candies";
ITEM.Description = "Remember to brush after you're done"; 
ITEM.Model = "models/props_lab/box01a.mdl"

ITEM.CamPos = Vector( 50, 50, 50 ) 
ITEM.LookAt = Vector( 0, 0, 2 ); 
ITEM.FOV = 17;
ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "ex";
ITEM.Amount = 5;

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

self.Owner:NoticePlainWhite( "Still closed, thankfully." );

end

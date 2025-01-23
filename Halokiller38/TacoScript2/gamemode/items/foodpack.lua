
ITEM.Name = "Food Package";

ITEM.Model = "models/weapons/w_package.mdl";

ITEM.Flags = "C";

ITEM.Width = 2;
ITEM.Height = 2;

ITEM.Price = 30;

ITEM.Description = "An unmarked food package.";

ITEM.InvWidth = 2;
ITEM.InvHeight = 2;

ITEM.CamPos = Vector( 84, 7, 150 );
ITEM.LookAt = Vector( -99, -23, -200 );
ITEM.FOV = 8;

function ITEM:FillContainer()

	self:GiveInventoryItem( "water" );
	self:GiveInventoryItem( "ratmeat" );
	self:GiveInventoryItem( "rice" );
	self:GiveInventoryItem( "horsemeat" );

end

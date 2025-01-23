
ITEM.Name = "Combine Ration";

ITEM.Model = "models/weapons/w_package.mdl";

ITEM.Flags = "u";

ITEM.Width = 2;
ITEM.Height = 2;

ITEM.Price = 30;

ITEM.Description = "A Combine issued food package containing all of your daily nutritious needs.";

ITEM.InvWidth = 2;
ITEM.InvHeight = 2;

ITEM.CamPos = Vector( 84, 7, 150 );
ITEM.LookAt = Vector( -99, -23, -200 );
ITEM.FOV = 8;

function ITEM:Use()

	self.Owner:AddMoney( 50 );
	self.Owner:GiveAnyInventoryItem( "water" );
	self.Owner:GiveAnyInventoryItem( "rice" );
	self.Owner:GiveAnyInventoryItem( "cannedbeans" );
	self.Owner:GiveAnyInventoryItem( "bread" );
	
end

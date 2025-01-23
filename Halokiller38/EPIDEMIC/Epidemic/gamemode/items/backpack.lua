
ITEM.Name = "Backpack";
ITEM.NicePhrase = "a backpack";
ITEM.Description = ""; 
ITEM.Model = "models/eltaco/backpack.mdl";

--Dummy data
ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 7 ); 
ITEM.FOV = 22;
--

ITEM.Width = 5;
ITEM.Height = 5;
ITEM.Flags = "ixp";

ITEM.Tier = 2;

ITEM.InventoryGrid = { }

function ITEM:Use()

	if( self.Owner:HasItemInventory( self.ID ) ) then
	
		return false;
	
	end

	self.Owner:AddNewInventoryWithItemData( self );
	self.Owner:AttachProp( "models/eltaco/backpack.mdl", "chest", true );

	self.Owner:sqlUpdateField( "HasBackpack", "1", true );

	return true;

end

function ITEM:Drop()

	self.Owner:DropItemProp( self );
	self.Owner:RemoveAttachmentFrom( "chest" );
	
	self.Owner:sqlUpdateField( "HasBackpack", "0", true );

end

function ITEM:Examine()

	self.Owner:NoticePlainWhite( "Rugged and black." );

end

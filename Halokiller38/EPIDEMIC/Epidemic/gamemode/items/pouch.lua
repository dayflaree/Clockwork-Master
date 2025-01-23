
ITEM.Name = "Pouch";
ITEM.NicePhrase = "a pouch";
ITEM.Description = ""; 
ITEM.Model = "models/weapons/w_defuser.mdl";

--Dummy data
ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 7 ); 
ITEM.FOV = 22;
--

ITEM.Width = 3;
ITEM.Height = 3;
ITEM.Flags = "ixp";

ITEM.Tier = 2;

ITEM.InventoryGrid = { }

function ITEM:Use()

	if( self.Owner:HasItemInventory( self.ID ) ) then
	
		return false;
	
	end

	self.Owner:AddNewInventoryWithItemData( self );
	self.Owner:AttachProp( "models/weapons/w_defuser.mdl", "chest", true );

	self.Owner:sqlUpdateField( "HasPouch", "1", true );

	return true;

end

function ITEM:Drop()

	self.Owner:DropItemProp( self );
	self.Owner:RemoveAttachmentFrom( "chest" );
	
	self.Owner:sqlUpdateField( "HasPouch", "0", true );

end

function ITEM:Examine()

	self.Owner:NoticePlainWhite( "A pair of black pouches." );

end

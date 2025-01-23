
ITEM.Name = "Vodka";

ITEM.Description = "A covered strange bottle, smells like alcohol."; 

ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Flags = "d@";

ITEM.Amount = 3;

ITEM.Price = 30;

function ITEM:Use()

	-- FIXME - rename to vodka, add some more booze
	
	self.Owner:GiveHealth( 3 );
	self.Owner:CallEvent( "HAlcoholBlur" );
	self.Owner:SetPlayerDrunkMul( math.Clamp( self.Owner:GetPlayerDrunkMul() + .14, 0, 1.6 ) );
	self.Owner.LastDrunkMulUpdate = CurTime();

end


ITEM.Model = "models/props_junk/glassjug01.mdl";
ITEM.CamPos = Vector( 200, -65, -14 );
ITEM.LookAt = Vector( 0, 0, 6 );
ITEM.FOV = 5;

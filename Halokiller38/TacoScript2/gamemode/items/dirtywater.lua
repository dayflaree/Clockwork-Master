
ITEM.Name = "Breen Water";

ITEM.Description = "Special Combine-issued water."; 

ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 3;

ITEM.Flags = "d@";

ITEM.Amount = 3;

function ITEM:Use()

	self.Owner:GiveHealth( 1 );
	self.Owner:SetPlayerSprint( math.Clamp( self.Owner:GetPlayerSprint() + 10, 0, 100 ) );
	self.Owner:CallEvent( "WaterBlur" );

end

ITEM.Model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.CamPos = Vector( 200, -135, 50 );
ITEM.LookAt = Vector( 0, 0, 0 );
ITEM.FOV = 6;

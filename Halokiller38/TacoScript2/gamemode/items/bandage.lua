
ITEM.Name = "Bandage Roll";

ITEM.Description = "A bandage roll, this can help stop bleeding"; 

ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 5;

ITEM.Flags = "u";

function ITEM:Use()

	self.Owner:SetPlayerSprint( self.Owner:GetPlayerEndurance() );
	
	if( self.Owner.IsBleeding ) then
		self.Owner:ResetBleeding();
	end
	
	self.Owner:SetPlayerBleeding( false );
	
	self.Owner:ResetBodyDamage();


end

ITEM.Model = "models/props/cs_office/Paper_towels.mdl";

ITEM.CamPos = Vector( 0, -42, 90 ); 
ITEM.LookAt = Vector( 0, -3, 5 );
ITEM.FOV = 17;

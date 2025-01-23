
ITEM.Name = "Medkit";

ITEM.Description = "Contains bandages, disinfectant spray, tweazers, plasters and water! This also stops bleeding."; 
ITEM.Model = "models/Items/HealthKit.mdl"

ITEM.CamPos = Vector( 7, 79, 55 ) 
ITEM.LookAt = Vector( 6, 8, 8 ) 
ITEM.FOV = 20;

ITEM.Width = 1;
ITEM.Height = 1;

ITEM.Price = 50;

ITEM.Flags = "u";

function ITEM:Use()

	self.Owner:GiveHealth( 25 );
	self.Owner:SetPlayerSprint( self.Owner:GetPlayerEndurance() );
	
	if( self.Owner.IsBleeding ) then
		self.Owner:ResetBleeding();
	end
	
	self.Owner:SetPlayerBleeding( false );
	
	self.Owner:ResetBodyDamage();


end

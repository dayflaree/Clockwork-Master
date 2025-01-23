ITEM.Name = "5.56mm Ammo";
ITEM.NicePhrase = "5.56mm ammo";
ITEM.Description = "Ammo"; 
ITEM.Model = "models/Items/BoxMRounds.mdl"
ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 7 ); 
ITEM.FOV = 22;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ax";
ITEM.Amount = 30;
ITEM.AmmoType = 3;

ITEM.Tier = 4;

ITEM.AddsOn = true;
ITEM.AddOnMax = 60;

function ITEM:Examine()

	self.Owner:NoticePlainWhite( "There are " .. self.Amount .. " rounds left in this." );

end


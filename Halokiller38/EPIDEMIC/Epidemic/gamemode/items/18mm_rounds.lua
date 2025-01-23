ITEM.Name = "18mm Ammo";
ITEM.NicePhrase = "18mm ammo";
ITEM.Description = "Ammo"; 
ITEM.Model = "models/Items/BoxBuckshot.mdl"
ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( 0, 0, 7 ); 
ITEM.FOV = 22;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ax";
ITEM.Amount = 30;
ITEM.AmmoType = 2;

ITEM.Tier = 4;

ITEM.AddsOn = true;
ITEM.AddOnMax = 60;

function ITEM:Examine()

	self.Owner:NoticePlainWhite( "There are " .. self.Amount .. " rounds left in this." );

end


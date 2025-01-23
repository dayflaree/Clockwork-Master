ITEM.Name = "Rad Away";
ITEM.Class = "med_radaway";
ITEM.Description = "Reduces your body's radiation level.";
ITEM.Model = "models/weapons/w_package.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 60;
ITEM.ItemGroup = 5;
ITEM.Weight = "1"
ITEM.Damage = "+75"
ITEM.DamageType = "Medication"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 50


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ChangeRADS( -250 );
	ply:ConCommand("say /me administers Rad Away to himself");
	self:Remove();

end

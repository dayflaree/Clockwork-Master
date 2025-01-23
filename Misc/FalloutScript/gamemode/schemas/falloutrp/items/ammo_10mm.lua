ITEM.Name = "10mm Ammo";
ITEM.Class = "ammo_10mm";
ITEM.Description = "24 Rounds";
ITEM.Model = "models/items/boxsrounds.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 75;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "Normal"
ITEM.AmmoType = "10mm"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 40
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:GiveAmmo(24,"pistol");
    self:Remove();
	
end

ITEM.Name = ".44 Magnum Ammo";
ITEM.Class = "ammo_44mn";
ITEM.Description = "20 Rounds";
ITEM.Model = "models/items/357ammobox.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 50;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "Normal"
ITEM.AmmoType = ".44 Magnum"
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

	ply:GiveAmmo(20,"357");
    self:Remove();
	
end

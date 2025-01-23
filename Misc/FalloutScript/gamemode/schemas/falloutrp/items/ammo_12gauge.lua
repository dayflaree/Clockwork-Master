ITEM.Name = "12-Gauge Shells";
ITEM.Class = "ammo_12gauge";
ITEM.Description = "20 Shells";
ITEM.Model = "models/items/boxbuckshot.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 225;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "Normal"
ITEM.AmmoType = "12 Gauge"
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

	ply:GiveAmmo(20,"buckshot");
    self:Remove();
	
end

ITEM.Name = "Milk";
ITEM.Class = "drink_milk";
ITEM.Description = "I doubt this is cow milk";
ITEM.Model = "models/props_junk/garbage_milkcarton002a.mdl"
ITEM.Purchaseable = true;
ITEM.Price = 5;
ITEM.ItemGroup = 5;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "N/A"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 40

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me drinks some milk");
	self:Remove();

end

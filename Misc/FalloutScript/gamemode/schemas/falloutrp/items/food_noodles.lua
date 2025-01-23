ITEM.Name = "Box of Noodles";
ITEM.Class = "food_noodles";
ITEM.Description = "Instant spaghetti";
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 35;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "N/A"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 50
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me eats a box of noodles");	
	self:Remove();

end

ITEM.Name = "Watermelon";
ITEM.Class = "food_watermelon";
ITEM.Description = "A big, fat, juicy melon";
ITEM.Model = "models/props_junk/watermelon01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 5;
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

	ply:ConCommand("/me eats a watermelon");
	self:Remove();

end

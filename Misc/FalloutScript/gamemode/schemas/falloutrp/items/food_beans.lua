ITEM.Name = "Pork N' Beans";
ITEM.Class = "beans";
ITEM.Description = "With Hickory Smoked Pig Chunks";
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl";
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

	ply:ConCommand("say /me eats some refried beans");
	self:Remove();

end

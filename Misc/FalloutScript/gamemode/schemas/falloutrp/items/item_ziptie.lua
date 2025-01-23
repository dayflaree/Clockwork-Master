ITEM.Name = "Ziptie";
ITEM.Class = "item_ziptie";
ITEM.Description = "Useful for tying something up";
ITEM.Model = "models/props_lab/box01a.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 15;
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

end

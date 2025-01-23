ITEM.Name = "Booze";
ITEM.Class = "drink_booze";
ITEM.Description = "Ancient liquor from the pre-war era";
ITEM.Model = "models/props/cs_militia/bottle01.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 10;
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

	LEMON.DrugPlayer(ply, 5);
	ply:ConCommand("say /me drinks some booze");
	self:Remove();

end

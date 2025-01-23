ITEM.Name = "Beer";
ITEM.Class = "drink_beer";
ITEM.Description = "Some kind of home-brewed beer";
ITEM.Model = "models/props_junk/garbage_glassbottle001a.mdl";
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

	LEMON.DrugPlayer(ply, 3);
	ply:ConCommand("say /me drinks some beer");
	self:Remove();

end

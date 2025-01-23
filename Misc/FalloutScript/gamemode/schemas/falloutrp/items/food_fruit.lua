ITEM.Name = "Fruit";
ITEM.Class = "food_fruit";
ITEM.Description = "Strange looking piece of fruit";
ITEM.Model = "models/props/cs_italy/orange.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 10;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "N/A"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 50
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

	self:SetColor( 139, 69, 19, 255 )

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me eats a fruit");	
	self:Remove();

end

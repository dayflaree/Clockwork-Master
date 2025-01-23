ITEM.Name = "Stimpak";
ITEM.Class = "med_stimpak";
ITEM.Description = "Provides immediate healing of minor wounds";
ITEM.Model = "models/weapons/w_package.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
ITEM.ItemGroup = 5;
ITEM.Weight = "1"
ITEM.Damage = "+75"
ITEM.DamageType = "Medication"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 50


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:SetHealth( ply:Health() + 25, 0, ply:MaxHealth());
	ply:ConCommand("say /me injects himself with a stimpak");
	self:Remove();

end

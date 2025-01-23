ITEM.Name = "Super Stimpak";
ITEM.Class = "med_superstimpak";
ITEM.Description = "May include side effects";
ITEM.Model = "models/weapons/w_package.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 225;
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

	ply:SetHealth( ply:Health() + 75, 0, ply:MaxHealth());
	
	timer.Create("stim1", 3, 1, ply:SetHealth( ply:Health() - 3, 0, ply:MaxHealth()))
	timer.Create("stim2", 6, 1, ply:SetHealth( ply:Health() - 6, 0, ply:MaxHealth()))
	
	ply:ConCommand("say /me injects himself with a super stimpak"); 
	self:Remove();

end

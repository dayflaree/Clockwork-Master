ITEM.Name = "Desert Eagle";
ITEM.Class = "bus_weapon_fs_deagle";
ITEM.Description = "Fully loaded";
ITEM.Model = "models/weapons/w_pist_deagle.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 800;
ITEM.ItemGroup = 5;
ITEM.Weight = "9"
ITEM.Damage = "10 - 16"
ITEM.DamageType = "Normal"
ITEM.AmmoType = ".44 Magnum"
ITEM.AmmoCapacity = "8"
ITEM.MinStrength = "5"
ITEM.Dist = 40




function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("weapon_fs_deagle");
	ply:GiveAmmo(8, "357");
	self:Remove();
ply:GetTable().ForceGive = false
end

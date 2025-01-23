ITEM.Name = "Winchester City-Killer";
ITEM.Class = "bus_weapon_fs_citykiller";
ITEM.Description = "Packed with shells";
ITEM.Model = "models/weapons/w_shot_m3super90.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 2750;
ITEM.ItemGroup = 5;
ITEM.Weight = "10"
ITEM.Damage = "15 - 25"
ITEM.DamageType = "Normal"
ITEM.AmmoType = "12 Gauge"
ITEM.AmmoCapacity = "12"
ITEM.MinStrength = 5
ITEM.Dist = 8



function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("weapon_fs_winchester");
	ply:GiveAmmo(12, "buckshot");
	self:Remove();
ply:GetTable().ForceGive = false
end

ITEM.Name = "Colt 6520 10mm Pistol";
ITEM.Class = "gun_fs_colt";
ITEM.Description = "Single shot only";
ITEM.Model = "models/weapons/w_pist_fiveseven.mdl"
ITEM.Purchaseable = true;
ITEM.Price = 250;
ITEM.Weight = "3"
ITEM.Damage = "5 - 12"
ITEM.DamageType = "Normal"
ITEM.AmmoType = "10mm"
ITEM.AmmoCapacity = 12
ITEM.MinStrength = 3
ITEM.Dist = 40
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("gun_fs_colt");
	self:Remove();
ply:GetTable().ForceGive = false
end

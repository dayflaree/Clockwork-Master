ITEM.Name = ".32 Hunting Rifle";
ITEM.Class = "gun_fs_rifle";
ITEM.Description = "Semi-Long Range Rifle";
ITEM.Model = "models/weapons/w_snip_rifle.mdl"
ITEM.Purchaseable = false;
ITEM.Price = 2200;
ITEM.Weight = "6"
ITEM.Damage = "25"
ITEM.DamageType = "Projectile"
ITEM.AmmoType = ".44 Magnum"
ITEM.AmmoCapacity = 5
ITEM.MinStrength = 5
ITEM.Dist = 8
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("gun_fs_rifle");
	self:Remove();
ply:GetTable().ForceGive = false
end

ITEM.Name = "Desert Eagle .44";
ITEM.Class = "gun_fs_deagle";
ITEM.Description = "Single shot only";
ITEM.Model = "models/weapons/w_pist_deagle.mdl"
ITEM.Purchaseable = true;
ITEM.Price = 800;
ITEM.Weight = "9"
ITEM.Damage = "10 - 16"
ITEM.DamageType = "Normal"
ITEM.AmmoType = ".44 Magnum"
ITEM.AmmoCapacity = 8
ITEM.MinStrength = 5
ITEM.Dist = 40
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("gun_fs_deagle");
	self:Remove();
ply:GetTable().ForceGive = false
end

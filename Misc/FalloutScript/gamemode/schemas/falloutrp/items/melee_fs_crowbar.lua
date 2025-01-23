ITEM.Name = "Repellent Stick";
ITEM.Class = "melee_fs_crowbar";
ITEM.Description = "Designed to ward off Mole Rats.";
ITEM.Model = "models/weapons/w_crowbar.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 5;
ITEM.Weight = "3"
ITEM.Damage = "3 - 10"
ITEM.DamageType = "Melee"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 1
ITEM.Dist = 8

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("melee_fs_crowbar");
	self:Remove();
ply:GetTable().ForceGive = false
end

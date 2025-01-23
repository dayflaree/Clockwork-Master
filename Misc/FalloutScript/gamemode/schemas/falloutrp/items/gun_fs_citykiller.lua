ITEM.Name = "Winchester City-Killer";
ITEM.Class = "gun_fs_citykiller";
ITEM.Description = "12-Gauge Combat Shotgun";
--ITEM.LongDescription = "A Winchester City-Killer 12 gauge combat shotgun, bullpup variant.\n In excellent condition, it has the optional DesertWarfare environmental sealant modification for extra reliability.\n"
ITEM.Model = "models/weapons/w_shot_m3super90.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2750;
ITEM.Weight = "10"
ITEM.Damage = "15 - 25"
ITEM.DamageType = "Normal"
ITEM.AmmoType = "12 Gauge"
ITEM.AmmoCapacity = 12
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
	ply:Give("gun_fs_citykiller");
	self:Remove();
ply:GetTable().ForceGive = false
end

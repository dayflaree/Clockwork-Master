ITEM.Name = "H&K P90c";
ITEM.Class = "bus_weapon_fs_p90c";
ITEM.Description = "Fully loaded";
ITEM.Model = "models/weapons/w_smg_p90.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2500;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("weapon_fs_p90c");
	ply:GiveAmmo(24, "smg1");
	self:Remove();
ply:GetTable().ForceGive = false
end

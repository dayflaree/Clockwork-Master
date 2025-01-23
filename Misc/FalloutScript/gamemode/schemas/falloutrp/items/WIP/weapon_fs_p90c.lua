ITEM.Name = "H&K P90c";
ITEM.Class = "weapon_fs_p90c";
ITEM.Description = "Simple and reliable";
ITEM.Model = "models/weapons/w_smg_p90.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2425;
ITEM.ItemGroup = 4;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("weapon_fs_p90c");
	self:Remove();
ply:GetTable().ForceGive = false
end

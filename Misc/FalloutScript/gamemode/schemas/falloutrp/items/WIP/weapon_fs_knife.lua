ITEM.Name = "Knife";
ITEM.Class = "weapon_fs_knife";
ITEM.Description = "Good for cutting and stabbing";
ITEM.Model = "models/weapons/w_knife_ct.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 40;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("weapon_fs_knife");
	self:Remove();
ply:GetTable().ForceGive = false
end

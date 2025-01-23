ITEM.Name = "Frag grenade";
ITEM.Class = "weapon_fraggrenade";
ITEM.Description = "Generic fragmentation grenade";
ITEM.Model = "models/weapons/w_eq_fraggrenade.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 20;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
ply:GetTable().ForceGive = true
	ply:Give("weapon_fraggrenade");
	self:Remove();
ply:GetTable().ForceGive = false
end

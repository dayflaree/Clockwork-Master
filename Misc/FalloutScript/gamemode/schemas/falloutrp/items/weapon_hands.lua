ITEM.Name = "Engine Hands";
ITEM.Class = "engine_hands";
ITEM.Description = "To prevent your client from crashing";
ITEM.Model = "models/weapons/w_shotgun.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 1;
ITEM.ItemGroup = 1;
ITEM.Weight = "0"
ITEM.Damage = "nil"
ITEM.DamageType = "nil"
ITEM.AmmoType = "nil"
ITEM.AmmoCapacity = "8"
ITEM.MinStrength = 5
ITEM.Dist = 40


function ITEM:Drop(ply)
	self:Remove();
end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	self:Remove();
end

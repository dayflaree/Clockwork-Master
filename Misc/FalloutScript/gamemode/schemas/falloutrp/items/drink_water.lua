ITEM.Name = "Clean Water";
ITEM.Class = "drink_water";
ITEM.Description = "A bottle of clean water.";
ITEM.Model = "models/props/cs_office/Water_bottle.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 3;
ITEM.ItemGroup = 5;
ITEM.Weight = "1"
ITEM.Damage = "+5"
ITEM.DamageType = "Healing"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 40



function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)
local plyhp = ply:Health()
	ply:ConCommand( "say /me drinks a bottle of water and keeps the cap" )
	ply:ChangeMoney( 1 )
	ply:SetHealth( plyhp + 5 )
	self:Remove()

end

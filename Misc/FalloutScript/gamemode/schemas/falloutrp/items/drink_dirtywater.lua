ITEM.Name = "Dirty Water";
ITEM.Class = "drink_dirtywater";
ITEM.Description = "A bottle of dirty water.";
ITEM.Model = "models/props/cs_office/Water_bottle.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 1;
ITEM.ItemGroup = 5;
ITEM.Weight = "1"
ITEM.Damage = "5"
ITEM.DamageType = "Unknown"
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

	ply:ConCommand( "say /me drinks a bottle of dirty water and keeps the cap." )
	ply:ChangeMoney( 1 )
	ply:TakeDamage( 5 )
	self:Remove()

end

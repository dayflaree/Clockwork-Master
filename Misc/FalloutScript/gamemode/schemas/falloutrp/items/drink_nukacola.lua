nukacolamodels = {}

nukacolamodels[1] = "models/props_junk/GlassBottle01a.mdl"
nukacolamodels[2] = "models/props_junk/GlassBottle01a.mdl"
-- nukacolamodels[3] = "models/nukacola/nukaq1.mdl"
-- nukacolamodels[4] = "models/nukacola/nukaq2.mdl"

local randomnukamodels = nukacolamodels[math.random( 1, 2 )]

ITEM.Name = "Nuka-Cola";
ITEM.Class = "drink_nukacola";
ITEM.Description = "Added with post-apocalyptic\n falvours!";
ITEM.Model = randomnukamodels
ITEM.Purchaseable = true;
ITEM.Price = 3;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "N/A"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 50
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand( "say /me drinks a bottle of Nuka-Cola and keeps the cap" )
	--ply:ChangeRADS( 40 )
	ply:ChangeMoney( 1 )
	ply:ChangeRADS( 20 )
	self:Remove()

end

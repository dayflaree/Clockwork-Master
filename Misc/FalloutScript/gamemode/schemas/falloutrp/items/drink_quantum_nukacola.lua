nukacolamodels = {}

-- nukacolamodels[1] = "models/nukacola/nukac1.mdl"
-- nukacolamodels[2] = "models/nukacola/nukac2.mdl"
nukacolamodels[1] = "models/props_junk/GlassBottle01a.mdl"
nukacolamodels[2] = "models/props_junk/GlassBottle01a.mdl"

local randomnukamodels = nukacolamodels[math.random( 1, 2 )]

ITEM.Name = "Nuka-Cola Quantum";
ITEM.Class = "drink_quantum_nukacola";
ITEM.Description = "A reformulated Nuka-Cola!";
ITEM.Model = randomnukamodels
ITEM.Purchaseable = true;
ITEM.Price = 30;
ITEM.ItemGroup = 5;
ITEM.Weight = "1"
ITEM.Damage = "N/A"
ITEM.DamageType = "N/A"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 50

-- function ITEM:Think()
 

-- end
	
function ITEM:Drop(ply)


	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand( "say /me drinks a bottle of Nuka-Cola Quantum and keeps the cap(AP Boost!)" )
	ply:SetNWInt( "apmod", 10 )
	ply:ChangeMoney( 1 )
	self:Remove()

end

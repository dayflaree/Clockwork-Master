nukacolamodels = {}

nukacolamodels[1] = "models/nukacola/nukac1.mdl"
nukacolamodels[2] = "models/nukacola/nukac2.mdl"
nukacolamodels[3] = "models/nukacola/nukaq1.mdl"
nukacolamodels[4] = "models/nukacola/nukaq2.mdl"

local randomnukamodels = nukacolamodels[math.random( 1, 4 )]

ITEM.Name = "Nuka-Cola";
ITEM.Class = "drink_nukacola";
ITEM.Description = "Added with post-apocalyptic falvours";
ITEM.Model = randomnukamodels
ITEM.Purchaseable = false;
ITEM.Price = 2;
ITEM.ItemGroup = 5;

function ITEM:Drop(ply)

	timer.Create( "selfremover", 30, 0, function()
		timer.Stop( "selfremover" )
		self:Remove()
	end )
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand( "say /me drinks a bottle of Nuka-Cola and keeps the cap" )
	ply:ChangeMoney( 1 )
	self:Remove()

end

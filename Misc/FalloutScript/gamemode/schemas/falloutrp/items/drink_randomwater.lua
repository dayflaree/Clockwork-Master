ITEM.Name = "Water";
ITEM.Class = "drink_randomwater";
ITEM.Description = "Is it clean?";
ITEM.Model = "models/props/cs_office/Water_bottle.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 2;
ITEM.ItemGroup = 5;
ITEM.Weight = "1"
ITEM.Damage = "Unknown"
ITEM.DamageType = "Unknown"
ITEM.AmmoType = "N/A"
ITEM.AmmoCapacity = "N/A"
ITEM.MinStrength = 0
ITEM.Dist = 40


local WaterStates = {}

WaterStates[1] = "clean"
WaterStates[2] = "dirty"
WaterStates[3] = "drugged"
WaterStates[4] = "fruity"
WaterStates[5] = "energy"
-- if GetGlobalInt( "ritem" ) == 1 then

	-- self:Remove()
	
-- end

local RandomWaterState = WaterStates[math.random( 1, 5 )]

function ITEM:Drop(ply)
	self:SetName( "ritem1" )
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

local plyhp = ply:Health()
	ply:ConCommand( "say /me drinks a bottle of ".. RandomWaterState .." water and keeps the cap." )
	ply:ChangeMoney( 1 )
	
	if RandomWaterState == WaterStates[1] then
	--print( "gave hp" ) debugger
	ply:SetHealth( plyhp + 5 )
	end
	
	if RandomWaterState == WaterStates[2] then
	--print( "took dmg" ) debugger
	ply:TakeDamage( 5 )
	end
	
	if RandomWaterState == WaterStates[3] then
	--print( "drugged" ) debugger
	ply:TakeDamage( 5 )
	LEMON.DrugPlayer( ply, 2 )
	end
	
	if RandomWaterState == WaterStates[4] then
	ply:SetHealth( plyhp + 10 )
	end
	
	if RandomWaterState == WaterStates[5] then
	ply:SetArmor( 10 )
	end
	self:Remove()

end

--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 5;
ITEM.name = "Milk Jugs";
ITEM.cost = 20;
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl";
ITEM.weight = 1;
ITEM.useText = "Drink";
ITEM.category = "Consumables"
ITEM.business = true;
ITEM.batch = 1;
ITEM.access = "v";
ITEM.description = "A jug filled with delicious milk.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 10, 0, 100));
	player:BoostAttribute(self("name"), ATB_ENDURANCE, 2, 600);
	player:BoostAttribute(self("name"), ATB_STRENGTH, 2, 600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);
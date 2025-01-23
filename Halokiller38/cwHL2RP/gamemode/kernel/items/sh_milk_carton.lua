--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 5;
ITEM.name = "Milk Carton";
ITEM.cost = 10;
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 0.8;
ITEM.useText = "Drink";
ITEM.category = "Consumables"
ITEM.business = true;
ITEM.batch = 1;
ITEM.access = "v";
ITEM.description = "A carton filled with delicious milk.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 5, 0, 100));
	player:BoostAttribute(self("name"), ATB_ENDURANCE, 1, 600);
	player:BoostAttribute(self("name"), ATB_STRENGTH, 1, 600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);
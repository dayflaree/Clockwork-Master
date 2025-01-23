local ITEM = {};

ITEM.name = "Water";
ITEM.cost = 20;
ITEM.batch = 1;
ITEM.model = "models/Fallout 3/water.mdl";
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.useText = "Drink";
ITEM.business = true;
ITEM.category = "Consumables"
ITEM.uniqueID = "water";
ITEM.description = "A dirty old water bottle, the water inside is obviously dirty.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + DESIGN:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	
	blueprint.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

blueprint.item.Register(ITEM);
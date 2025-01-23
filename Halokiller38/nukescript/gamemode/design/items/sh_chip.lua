local ITEM = {};

ITEM.name = "Potato Crisps";
ITEM.cost = 15;
ITEM.batch = 1;
ITEM.model = "models/Fallout 3/chips.mdl";
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.useText = "Eat";
ITEM.business = true;
ITEM.category = "Consumables"
ITEM.uniqueID = "pcrisps";
ITEM.description = "An old beaten up crisp box, junk food.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + DESIGN:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	
	blueprint.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

blueprint.item.Register(ITEM);
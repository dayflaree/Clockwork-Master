local ITEM = {};

ITEM.name = "Vodka";
ITEM.cost = 50;
ITEM.batch = 1;
ITEM.model = "models/Fallout 3/vodka.mdl";
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.useText = "Drink";
ITEM.business = true;
ITEM.category = "Alcohol"
ITEM.uniqueID = "vodka";
ITEM.description = "A dirty vodka bottle, it smells pretty strong.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + DESIGN:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	
	blueprint.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

blueprint.item.Register(ITEM);
local ITEM = {};

ITEM.name = "Pork N' Beans";
ITEM.cost = 30;
ITEM.batch = 1;
ITEM.model = "models/Fallout 3/beans.mdl";
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.useText = "Eat";
ITEM.business = true;
ITEM.category = "Consumables"
ITEM.uniqueID = "beans";
ITEM.description = "A rusty tin can of beans, looks filling yet...disgusting.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + DESIGN:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	
	blueprint.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

blueprint.item.Register(ITEM);
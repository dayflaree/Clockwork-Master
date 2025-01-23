--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 5;
ITEM.cost = 20;
ITEM.name = "Breen's Reserve";
ITEM.uniqueid = "breens_reserve";
ITEM.model = "models/props_junk/PopCan01a.mdl";
ITEM.weight = 0.5;
ITEM.useText = "Ingest";
ITEM.category = "Consumables"
ITEM.business = true;
ITEM.batch = 1;
ITEM.description = "A can that swishes when you shake it... you wonder what could be inside";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 5, 0, player:GetMaxHealth()));
	player:BoostAttribute(self("name"), ATB_ENDURANCE, 16, 600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);
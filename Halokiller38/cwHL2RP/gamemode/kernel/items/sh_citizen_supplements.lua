--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 5;
ITEM.name = "Citizen Supplements";
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 0.8;
ITEM.useText = "Ingest";
ITEM.category = "Consumables"
ITEM.business = false;
ITEM.description = "A can that swishes when you shake it... you wonder what could be inside";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 20, 0, player:GetMaxHealth()));
	player:BoostAttribute(self("name"), ATB_ENDURANCE, 16, 600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);
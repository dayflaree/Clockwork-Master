--[[
Name: "sh_beer.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "drug_base";
ITEM.cost = 30;
ITEM.name = "Stimpack";
ITEM.model = "models/clutter/stimpack.mdl";
ITEM.batch = 1;
ITEM.weight = 0.10;
ITEM.access = "T";
ITEM.business = true;
ITEM.description = "A stimpack, helpful in situations where you're hurt, does not stop bleeding out.";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:SetHealth( math.Clamp( player:Health() + 20, 0, player:GetMaxHealth() ) );
end;

blueprint.item.Register(ITEM);

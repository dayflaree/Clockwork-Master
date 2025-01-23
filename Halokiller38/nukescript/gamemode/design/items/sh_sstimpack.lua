--[[
Name: "sh_beer.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "drug_base";
ITEM.cost = 60;
ITEM.name = "Super Stimpack";
ITEM.model = "models/fallout/items/superstimpack01.mdl";
ITEM.batch = 1;
ITEM.weight = 0.10;
ITEM.access = "T";
ITEM.business = false;
ITEM.description = "A super stimpack, helpful in situations where you're hurt, does not stop bleeding out.";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:SetHealth( math.Clamp( player:Health() + 40, 0, player:GetMaxHealth() ) );
end;

blueprint.item.Register(ITEM);

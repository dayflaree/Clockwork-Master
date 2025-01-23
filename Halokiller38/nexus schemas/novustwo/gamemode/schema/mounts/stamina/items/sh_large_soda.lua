--[[
Name: "sh_large_soda.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Large Soda";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.batch = 1;
ITEM.weight = 0.5;
ITEM.access = "T";
ITEM.useText = "Drink";
ITEM.business = true;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "Consumables";
ITEM.description = "A plastic bottle, it's fairly big and filled with liquid.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 8, 0, player:GetMaxHealth() ) );
	player:UpdateInventory("empty_soda_bottle", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);
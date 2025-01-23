--[[
Name: "sh_chinese_takeout.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Chinese Takeout";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.batch = 1;
ITEM.weight = 0.35;
ITEM.access = "T";
ITEM.useText = "Eat";
ITEM.business = true;
ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
ITEM.category = "Consumables"
ITEM.description = "A takeout carton, it's filled with cold noodles.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 8, 0, player:GetMaxHealth() ) );
	player:UpdateInventory("empty_takeout_carton", 1, true);
	player:BoostAttribute("Hunger", ATB_ENDURANCE, 30, 3600);
	player:BoostAttribute("Hunger", ATB_STRENGTH, 30, 3600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);
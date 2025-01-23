--[[
Name: "sh_melon.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Melon";
ITEM.cost = 10;
ITEM.model = "models/props_junk/watermelon01.mdl";
ITEM.batch = 1;
ITEM.weight = 0.35;
ITEM.access = "T";
ITEM.useText = "Eat";
ITEM.business = true;
ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
ITEM.category = "Consumables"
ITEM.description = "A green fruit, it has a hard outer shell.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 8, 0, 100) );
	player:BoostAttribute("Hunger", ATB_ENDURANCE, 30, 3600);
	player:BoostAttribute("Hunger", ATB_STRENGTH, 30, 3600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);
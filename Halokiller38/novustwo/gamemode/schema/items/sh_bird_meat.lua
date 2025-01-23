--[[
Name: "sh_bird_meat.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Bird Meat";
ITEM.model = "models/gibs/antlion_gib_small_1.mdl";
ITEM.weight = 0.35;
ITEM.plural = "Bird Meat";
ITEM.useText = "Eat";
ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
ITEM.category = "Consumables"
ITEM.isRareItem = true;
ITEM.description = "Meat ripped from the body of a bird, it smells disgusting.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 8, 0, 100) );
	player:BoostAttribute("Sickening", ATB_ACROBATICS, -30, 3600);
	player:BoostAttribute("Sickening", ATB_AGILITY, -30, 3600);
	player:BoostAttribute("Hunger", ATB_STRENGTH, 30, 3600);
	player:BoostAttribute("Hunger", ATB_ENDURANCE, 30, 3600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/flesh");
end;

nexus.item.Register(ITEM);
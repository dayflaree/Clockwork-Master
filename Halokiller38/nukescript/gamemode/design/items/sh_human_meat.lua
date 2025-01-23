--[[
Name: "sh_human_meat.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.name = "Human Meat";
ITEM.model = "models/Gibs/Antlion_gib_small_2.mdl";
ITEM.weight = 0.35;
ITEM.plural = "Human Meat";
ITEM.useText = "Eat";
ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
ITEM.category = "Consumables"
ITEM.isRareItem = true;
ITEM.description = "Meat ripped from the body of a human, it smells disgusting.";

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

blueprint.item.Register(ITEM);
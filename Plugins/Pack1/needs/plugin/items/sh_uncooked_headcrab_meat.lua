local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Uncooked Headcrab Meat";
ITEM.uniqueID = "uncooked_headcrab_meat";
-- ITEM.spawnValue = 14; // Should not be spawned since it's a 'event' item.
-- ITEM.spawnType = "consumable"; // Should not be spawned since it's a 'event' item.
ITEM.cost = 25;
ITEM.model = "models/gibs/antlion_gib_small_2.mdl";
ITEM.useSound = {"npc/barnacle/barnacle_die1.wav", "npc/barnacle/barnacle_die2.wav"};
ITEM.weight = 0.2;
ITEM.hunger = 15;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.faction = {FACTION_VORT}
ITEM.description = "A filé of uncooked headcrab meat. It smells disgusting.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:TakeDamage(6, player, player);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();
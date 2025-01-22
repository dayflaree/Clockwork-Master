local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Roast Turkey";
ITEM.uniqueID = "turkey";
ITEM.model = "models/bioshockinfinite/cottoncandy.mdl";
ITEM.description = "A real golden-brown turkey leg, god knows how this was sourced. Nevertheless, the powers that be in the outlands have provided you with a would-be Christmas dinner.";
ITEM.weight = 0.4;
ITEM.hunger = 75;
ITEM.health = 10;

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("phoenix_storms/trains/track_beamside");
end;

ITEM:Register();
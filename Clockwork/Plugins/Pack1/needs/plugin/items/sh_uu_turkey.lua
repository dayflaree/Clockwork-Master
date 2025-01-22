local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Turkey";
ITEM.uniqueID = "uu_turkey";
ITEM.model = "models/bioshockinfinite/cottoncandy.mdl";
ITEM.description = "A synthetic turkey leg, with the UU Brand seared into it. The meat is floppy, greasy and clearly synthetic; but hey, it's Christmas.";
ITEM.category = "UU-Branded Items";
ITEM.weight = 0.4;
ITEM.hunger = 75;
ITEM.health = 10;

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("phoenix_storms/trains/track_beamside");
end;

ITEM:Register();
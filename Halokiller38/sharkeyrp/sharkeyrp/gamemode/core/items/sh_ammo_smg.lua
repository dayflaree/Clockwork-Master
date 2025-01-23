local ITEM = {};
ITEM.derive = "ammo_base";
ITEM.name = "SMG Ammo";
ITEM.category = "Ammo";
ITEM.model = "models/Items/BoxMRounds.mdl";

ITEM.ammoClass = "smg1";
ITEM.rounds = 40;

ITEM.job = "weapon_dealer";
ITEM.cost = 150;

RP.item:New(ITEM);
local ITEM = {};
ITEM.derive = "ammo_base";
ITEM.name = "9mm Ammo";
ITEM.category = "Ammo";
ITEM.model = "models/Items/BoxSRounds.mdl";

ITEM.ammoClass = "Pistol";
ITEM.rounds = 20;

ITEM.job = "weapon_dealer";
ITEM.cost = 100;

RP.Item:New(ITEM);
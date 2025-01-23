local ITEM = {};
ITEM.derive = "ammo_base";
ITEM.name = ".357 Ammo";
ITEM.category = "Ammo";
ITEM.model = "models/Items/357ammo.mdl";

ITEM.ammoClass = "357";
ITEM.rounds = 12;

ITEM.job = "weapon_dealer";
ITEM.cost = 200;

RP.Item:New(ITEM);
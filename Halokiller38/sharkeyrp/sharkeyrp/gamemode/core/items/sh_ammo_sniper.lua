local ITEM = {};
ITEM.derive = "ammo_base";
ITEM.name = "Sniper Ammo";
ITEM.category = "Ammo";
ITEM.model = "models/Items/357ammobox.mdl";

ITEM.ammoClass = "SniperRound";
ITEM.rounds = 12;

ITEM.job = "weapon_dealer";
ITEM.cost = 300;

RP.item:New(ITEM);
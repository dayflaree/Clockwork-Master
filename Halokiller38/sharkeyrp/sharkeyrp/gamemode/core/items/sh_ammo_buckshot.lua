local ITEM = {};
ITEM.derive = "ammo_base";
ITEM.name = "Buckshot Ammo";
ITEM.category = "Ammo";
ITEM.model = "models/Items/BoxBuckshot.mdl";

ITEM.ammoClass = "Buckshot";
ITEM.rounds = 12;

ITEM.job = "weapon_dealer";
ITEM.cost = 250;

RP.item:New(ITEM);
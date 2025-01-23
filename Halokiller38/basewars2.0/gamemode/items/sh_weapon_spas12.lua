local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "SPAS12";
ITEM.model = "models/weapons/w_shotgun.mdl";
ITEM.weaponClass = "weapon_mad_spas";
ITEM.ammoClass = "buckshot"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 5000;

RP.Item:New(ITEM);
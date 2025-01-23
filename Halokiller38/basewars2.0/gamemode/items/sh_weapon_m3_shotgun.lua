local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Benelli M3 Super 90";
ITEM.model = "models/weapons/w_shot_m3super90.mdl";
ITEM.weaponClass = "weapon_mad_m3";
ITEM.ammoClass = "buckshot"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 4900;

RP.Item:New(ITEM);
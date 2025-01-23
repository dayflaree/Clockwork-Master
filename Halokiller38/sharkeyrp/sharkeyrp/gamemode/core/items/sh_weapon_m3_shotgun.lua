local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "M3 Shotgun";
ITEM.model = "models/weapons/w_shot_m3super90.mdl";
ITEM.weaponClass = "weapon_mad_m3";
ITEM.ammoClass = "buckshot"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 4900;

RP.item:New(ITEM);
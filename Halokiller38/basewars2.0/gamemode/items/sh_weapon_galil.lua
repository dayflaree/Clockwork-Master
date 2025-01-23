local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "IMI Galil";
ITEM.model = "models/weapons/w_rif_galil.mdl";
ITEM.weaponClass = "weapon_mad_galil";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 3750;

RP.Item:New(ITEM);
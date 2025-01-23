local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Famas";
ITEM.model = "models/weapons/w_rif_famas.mdl";
ITEM.weaponClass = "weapon_mad_famas";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 3600;

RP.item:New(ITEM);
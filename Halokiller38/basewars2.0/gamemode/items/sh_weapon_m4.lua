local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "M4A1 Carbine";
ITEM.model = "models/weapons/w_rif_m4a1.mdl";
ITEM.weaponClass = "weapon_mad_m4";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 4500;

RP.Item:New(ITEM);
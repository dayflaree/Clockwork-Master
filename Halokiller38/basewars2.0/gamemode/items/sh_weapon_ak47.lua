local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "AK47";
ITEM.model = "models/weapons/w_rif_ak47.mdl";
ITEM.weaponClass = "weapon_mad_ak47";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 3500;

RP.Item:New(ITEM);
local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Sig 552";
ITEM.model = "models/weapons/w_rif_sg552.mdl";
ITEM.weaponClass = "weapon_mad_sg552";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 6500;

RP.item:New(ITEM);
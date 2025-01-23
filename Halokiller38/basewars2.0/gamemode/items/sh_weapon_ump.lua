local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "UMP45";
ITEM.model = "models/weapons/w_smg_ump45.mdl";
ITEM.weaponClass = "weapon_mad_ump";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 3000;

RP.Item:New(ITEM);
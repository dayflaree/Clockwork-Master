local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "MP5";
ITEM.model = "models/weapons/w_smg_mp5.mdl";
ITEM.weaponClass = "weapon_mad_mp5";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 3150;

RP.Item:New(ITEM);
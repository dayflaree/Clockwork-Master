local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "TMP";
ITEM.model = "models/weapons/w_smg_tmp.mdl";
ITEM.weaponClass = "weapon_mad_tmp";
ITEM.ammoClass = "pistol"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 2600;

RP.item:New(ITEM);
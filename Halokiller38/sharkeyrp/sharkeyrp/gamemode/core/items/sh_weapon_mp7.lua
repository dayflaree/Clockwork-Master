local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "MP7";
ITEM.model = "models/weapons/w_smg1.mdl";
ITEM.weaponClass = "weapon_mad_mp7";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 3300;

RP.item:New(ITEM);
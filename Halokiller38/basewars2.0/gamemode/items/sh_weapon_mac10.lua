local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "MAC-10";
ITEM.model = "models/weapons/w_smg_mac10.mdl";
ITEM.weaponClass = "weapon_mad_mac10";
ITEM.ammoClass = "pistol"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 2250;

RP.Item:New(ITEM);
local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Benelli M4 Super 90";
ITEM.model = "models/weapons/w_shot_xm1014.mdl";
ITEM.weaponClass = "weapon_mad_xm1014";
ITEM.ammoClass = "buckshot"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 5100;

RP.Item:New(ITEM);
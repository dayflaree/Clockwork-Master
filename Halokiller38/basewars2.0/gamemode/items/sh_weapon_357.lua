local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "357 Magnum";
ITEM.model = "models/weapons/w_357.mdl";
ITEM.weaponClass = "weapon_mad_357";
ITEM.ammoClass = "pistol"

ITEM.isSecondary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 1500;

RP.Item:New(ITEM);
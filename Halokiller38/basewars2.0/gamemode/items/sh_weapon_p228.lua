local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "P228";
ITEM.model = "models/weapons/w_pist_p228.mdl";
ITEM.weaponClass = "weapon_mad_p228";
ITEM.ammoClass = "pistol"

ITEM.isSecondary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 525;

RP.Item:New(ITEM);
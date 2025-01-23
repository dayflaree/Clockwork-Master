local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Desert Eagle";
ITEM.model = "models/weapons/w_pist_deagle.mdl";
ITEM.weaponClass = "weapon_mad_deagle";
ITEM.ammoClass = "pistol"

ITEM.isSecondary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 1650;

RP.Item:New(ITEM);
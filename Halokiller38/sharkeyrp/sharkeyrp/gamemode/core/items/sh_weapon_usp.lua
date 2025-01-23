local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "USP";
ITEM.model = "models/weapons/w_pist_usp.mdl";
ITEM.weaponClass = "weapon_mad_usp";
ITEM.ammoClass = "pistol"

ITEM.isSecondary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 1000;

RP.item:New(ITEM);
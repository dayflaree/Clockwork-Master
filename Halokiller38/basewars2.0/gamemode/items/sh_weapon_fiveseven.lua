local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Five-Seven";
ITEM.model = "models/weapons/w_pist_fiveseven.mdl";
ITEM.weaponClass = "weapon_mad_57";
ITEM.ammoClass = "pistol"

ITEM.isSecondary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 750;

RP.Item:New(ITEM);
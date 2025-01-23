local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "M249";
ITEM.model = "models/weapons/w_mach_m249para.mdl";
ITEM.weaponClass = "weapon_mad_m249";
ITEM.ammoClass = "smg1"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 4000;

RP.item:New(ITEM);
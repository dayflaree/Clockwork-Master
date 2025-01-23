local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Glock 18";
ITEM.model = "models/weapons/w_pist_glock18.mdl";
ITEM.weaponClass = "weapon_mad_glock";
ITEM.ammoClass = "pistol"

ITEM.isSecondary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 500;

RP.Item:New(ITEM);
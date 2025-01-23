local ITEM = {};
ITEM.derive = "weapon_base";
ITEM.name = "Scout Sniper";
ITEM.model = "models/weapons/w_snip_scout.mdl";
ITEM.weaponClass = "weapon_mad_scout";
ITEM.ammoClass = "StriderMinigun"

ITEM.isPrimary = true;

ITEM.job = "weapon_dealer";
ITEM.cost = 5000;

RP.item:New(ITEM);
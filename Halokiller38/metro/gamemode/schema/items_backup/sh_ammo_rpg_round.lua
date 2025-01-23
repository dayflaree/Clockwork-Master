
--[[
Name: "sh_ammo_rpg_round.lua".
Product: "HL2 RP".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "ammo_base";
ITEM.name = "RPG Missile";
ITEM.model = "models/weapons/w_missile_launch.mdl";
ITEM.access = "V";
ITEM.weight = 2;
ITEM.uniqueID = "ammo_rpg_round";
ITEM.business = true;
ITEM.ammoClass = "rpg_round";
ITEM.ammoAmount = 1;
ITEM.description = "A orange and white colored rocket, what would happen if I dropped this?";
ITEM.cost = 50;
ITEM.access = "A";

openAura.item:Register(ITEM);
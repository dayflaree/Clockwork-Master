--[[
Name: "sh_hula_doll.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Hula Doll";
ITEM.worth = 1;
ITEM.model = "models/props_lab/huladoll.mdl";
ITEM.weight = 0.1
ITEM.description = "A Hula Doll, it sways from side to side.";

nexus.item.Register(ITEM);
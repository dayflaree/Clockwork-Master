--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "alcohol_base";
ITEM.cost = 100;
ITEM.name = "Vodka";
ITEM.model = "models/stalker/item/food/vokda.mdl";
ITEM.batch = 1;
ITEM.weight = 0.25;
ITEM.business = true;
ITEM.access = "T";
ITEM.description = "A glass bottle filled with liquid, it has a funny smell.";

openAura.item:Register(ITEM);
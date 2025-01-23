--[[
Name: "sh_chinese_takeout.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Chinese Takeout";
ITEM.cost = 8;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.8;
ITEM.access = "v";
ITEM.useText = "Eat";
ITEM.category = "Consumables";
ITEM.business = true;
ITEM.description = "A takeout carton, it's filled with cold noodles.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 10, 0, player:GetMaxHealth() ) );
	
	player:BoostAttribute(self.name, ATB_ENDURANCE, 2, 120);
	player:BoostAttribute(self.name, ATB_ACCURACY, 1, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

resistance.item.Register(ITEM);
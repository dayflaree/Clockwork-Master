--[[
Name: "sh_metropolice_supplements.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Metropolice Supplements";
ITEM.cost = 10;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 0.6;
ITEM.useText = "Eat";
ITEM.factions = {FACTION_MPF};
ITEM.category = "Consumables";
ITEM.business = true;
ITEM.description = "A tinned can, it slushes when you shake it.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 5, 0, player:GetMaxHealth() ) );
	player:BoostAttribute(self.name, ATB_ENDURANCE, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

resistance.item.Register(ITEM);
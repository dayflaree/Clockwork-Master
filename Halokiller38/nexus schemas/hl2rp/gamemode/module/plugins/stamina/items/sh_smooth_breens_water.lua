--[[
Name: "sh_smooth_breens_water.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Smooth Breen's Water";
ITEM.cost = 10;
ITEM.skin = 1;
ITEM.model = "models/props_junk/popcan01a.mdl";
ITEM.weight = 0.5;
ITEM.access = "1";
ITEM.useText = "Drink";
ITEM.business = true;
ITEM.factions = {FACTION_MPF};
ITEM.category = "Consumables";
ITEM.description = "A red aluminium can, it swishes when you shake it.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 100);
	player:SetHealth( math.Clamp( player:Health() + 6, 0, player:GetMaxHealth() ) );
	
	player:BoostAttribute(self.name, ATB_AGILITY, 2, 120);
	player:BoostAttribute(self.name, ATB_STAMINA, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item's functions should be edited.
function ITEM:OnEditFunctions(functions)
	if ( MODULE:PlayerIsCombine(g_LocalPlayer, false) ) then
		for k, v in pairs(functions) do
			if (v == "Drink") then functions[k] = nil; end;
		end;
	end;
end;

resistance.item.Register(ITEM);
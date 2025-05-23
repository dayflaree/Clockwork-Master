--[[
Name: "sh_canned_beans.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "Canned Beans";
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 0.6;
ITEM.useText = "Eat";
ITEM.category = "Consumables"
ITEM.description = "A tinned can, it slushes when you shake it.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 5, 0, player:GetMaxHealth() ) );
	
	player:BoostAttribute(self.name, ATB_ENDURANCE, 1, 600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);
--[[
Name: "sh_steroids.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "Steroids";
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
ITEM.weight = 0.2;
ITEM.useText = "Swallow";
ITEM.category = "Medical";
ITEM.description = "A tin of pills, don't do drugs!";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:BoostAttribute(self.name, ATB_STAMINA, 8, 3600);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);
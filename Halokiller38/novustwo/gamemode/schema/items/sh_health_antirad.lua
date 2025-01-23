--[[
Name: "sh_bandage.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Anti-Rad";
ITEM.cost = 220; 
ITEM.model = "models/hgn/srp/items/antirads.mdl";
ITEM.batch = 1;
ITEM.weight = 0.01;
ITEM.access = "T";
ITEM.useText = "Apply";
ITEM.business = true;
ITEM.category = "Medical"
ITEM.useSound = "items/medshot4.wav";
ITEM.uniqueID = "antirad";
ITEM.description = "Reduces radiation by 66%.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData( "radiation", math.Clamp(player:GetCharacterData("radiation") - 66, 0, 100) )
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);
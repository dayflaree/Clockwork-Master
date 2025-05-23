--[[
Name: "sh_steroids.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Steroids";
ITEM.cost = 12;
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
ITEM.batch = 1;
ITEM.weight = 0.1;
ITEM.access = "T";
ITEM.useText = "Swallow";
ITEM.business = true;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "Medical";
ITEM.description = "A tin of pills, don't do drugs!";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:BoostAttribute(self.name, ATB_STAMINA, 8, 3600);
	player:UpdateInventory("empty_tin_can", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);
--[[
Name: "sh_canned_beans.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.name = "Canned Beans";
ITEM.cost = 1;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.batch = 1;
ITEM.weight = 0.3;
ITEM.access = "My59";
ITEM.useText = "Eat";
ITEM.business = true;
ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
ITEM.category = "Consumables";
ITEM.description = "A tinned can, it slushes when you shake it.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 4, 0, player:GetMaxHealth() ) );
	player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 100, 0, 100) );

	player:UpdateInventory("empty_plastic_jar", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);
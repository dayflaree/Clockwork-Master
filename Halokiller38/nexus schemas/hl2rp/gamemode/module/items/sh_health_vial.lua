--[[
Name: "sh_health_vial.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Health Vial";
ITEM.cost = 15;
ITEM.model = "models/healthvial.mdl";
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.useText = "Drink";
ITEM.factions = {FACTION_MPF, FACTION_OTA};
ITEM.category = "Medical"
ITEM.business = true;
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A strange vial filled with green liquid, be careful.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + MODULE:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	
	resistance.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			resistance.player.RunResistanceCommand(player, "CharHeal", "health_vial");
		end;
	end;
end;

resistance.item.Register(ITEM);
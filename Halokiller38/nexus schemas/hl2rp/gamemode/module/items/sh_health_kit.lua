--[[
Name: "sh_health_kit.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Health Kit";
ITEM.cost = 30;
ITEM.model = "models/items/healthkit.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.useText = "Apply";
ITEM.factions = {FACTION_MPF, FACTION_OTA};
ITEM.category = "Medical"
ITEM.business = true;
ITEM.useSound = "items/medshot4.wav";
ITEM.blacklist = {CLASS_MPR};
ITEM.description = "A white packet filled with medication.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + MODULE:GetHealAmount(player, 2), 0, player:GetMaxHealth() ) );
	
	resistance.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			resistance.player.RunResistanceCommand(player, "CharHeal", "health_kit");
		end;
	end;
end;

resistance.item.Register(ITEM);
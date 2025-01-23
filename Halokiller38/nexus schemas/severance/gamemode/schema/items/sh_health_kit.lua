--[[
Name: "sh_health_kit.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "BioKit";
ITEM.model = "models/items/healthkit.mdl";
ITEM.weight = 1;
ITEM.useText = "Apply";
ITEM.category = "Medical"
ITEM.uniqueID = "health_kit";
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A white packet filled with strange, high tech medication.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + SCHEMA:GetHealAmount(player, 2), 0, player:GetMaxHealth() ) );
	
	nexus.mount.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			nexus.player.RunNexusCommand(player, "CharHeal", "health_kit");
		end;
	end;
end;

nexus.item.Register(ITEM);
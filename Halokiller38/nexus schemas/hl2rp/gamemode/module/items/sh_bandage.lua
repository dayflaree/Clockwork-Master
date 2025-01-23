--[[
Name: "sh_bandage.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Bandage";
ITEM.cost = 8;
ITEM.model = "models/props_wasteland/prison_toiletchunk01f.mdl";
ITEM.weight = 0.5;
ITEM.access = "1v";
ITEM.useText = "Apply";
ITEM.category = "Medical"
ITEM.business = true;
ITEM.description = "A bandage roll, there isn't much so use it wisely.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + MODULE:GetHealAmount(player), 0, player:GetMaxHealth() ) );
	
	resistance.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			resistance.player.RunResistanceCommand(player, "CharHeal", "bandage");
		end;
	end;
end;

resistance.item.Register(ITEM);
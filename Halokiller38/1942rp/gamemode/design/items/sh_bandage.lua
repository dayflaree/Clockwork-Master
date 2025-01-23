--[[
Name: "sh_bandage.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.name = "Bandage";
ITEM.cost = 4; 
ITEM.model = "models/props_wasteland/prison_toiletchunk01f.mdl";
ITEM.batch = 1;
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.useText = "Apply";
ITEM.business = true;
ITEM.category = "Medical"
ITEM.description = "A bandage roll, there isn't much so use it wisely.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + DESIGN:GetHealAmount(player), 0, player:GetMaxHealth() ) );
	
	blueprint.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			blueprint.player.RunBlueprintCommand(player, "CharHeal", "bandage");
		end;
	end;
end;

blueprint.item.Register(ITEM);
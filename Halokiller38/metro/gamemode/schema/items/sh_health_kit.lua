--[[
Name: "sh_health_kit.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "BioKit";
ITEM.model = "models/items/healthkit.mdl";
ITEM.weight = 1;
ITEM.cost = 9;
ITEM.access = "M";
ITEM.business = true;
ITEM.useText = "Apply";
ITEM.category = "Medical";
ITEM.uniqueID = "health_kit";
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A white packet filled with strange, high tech medication.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + openAura.schema:GetHealAmount(player, 2), 0, player:GetMaxHealth() ) );
	player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 20, 0, 100) );
	openAura.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			openAura.player:RunOpenAuraCommand(player, "CharHeal", "health_kit");
		end;
	end;
end;

openAura.item:Register(ITEM);
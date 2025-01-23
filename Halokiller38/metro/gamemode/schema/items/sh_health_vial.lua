--[[
Name: "sh_health_vial.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "BioVial";
ITEM.model = "models/healthvial.mdl";
ITEM.weight = 0.5;
ITEM.useText = "Drink";
ITEM.cost = 5;
ITEM.access = "M";
ITEM.business = true;
ITEM.category = "Medical";
ITEM.useSound = "items/medshot4.wav";
ITEM.uniqueID = "health_vial";
ITEM.description = "A strange vial filled with green liquid, be careful.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + openAura.schema:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 20, 0, 100) );
	openAura.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			openAura.player:RunOpenAuraCommand(player, "CharHeal", "health_vial");
		end;
	end;
end;

openAura.item:Register(ITEM);
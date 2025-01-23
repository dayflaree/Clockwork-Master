--[[
Name: "sh_antibiotics.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "Antibiotics";
ITEM.cost = 2;
ITEM.model = "models/healthvial.mdl";
ITEM.weight = 0.2;
ITEM.access = "M";
ITEM.useText = "Swallow";
ITEM.business = true;
ITEM.category = "Medical";
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A strange vial filled drugs, it says 'take twice a day' on the bottle.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + openAura.schema:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 75, 0, 100) );

	
	openAura.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			openAura.player:RunOpenAuraCommand(player, "CharHeal", "antibiotics");
		end;
	end;
end;

openAura.item:Register(ITEM);
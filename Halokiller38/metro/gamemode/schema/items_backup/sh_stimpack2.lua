--[[
Name: "sh_antibiotics.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.name = "Booster";
ITEM.cost = 3;
ITEM.batch = 1;
ITEM.model = "models/stalker/item/medical/booster.mdl";
ITEM.weight = 0.4;
ITEM.access = "M";
ITEM.useText = "Inject";
ITEM.business = true;
ITEM.category = "Medical";
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A medical stimpack, it says 'Military' on the front of it.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + openAura.schema:GetHealAmount(player, 3), 0, player:GetMaxHealth() ) );
	player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 75, 0, 80) );

	
	openAura.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			openAura.player:RunOpenAuraCommand(player, "CharHeal", "stimpack");
		end;
	end;
end;

openAura.item:Register(ITEM);
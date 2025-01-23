--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.name = "Red Health Kit";
ITEM.cost = 500;
ITEM.batch = 1;
ITEM.model = "models/stalker/item/medical/medkit1.mdl";
ITEM.weight = 0.2;
ITEM.business = true;
ITEM.useText = "Use";
ITEM.business = true;
ITEM.access = "T";
ITEM.category = "Medical"
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "A large red kit with an health symbol outside.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + openAura.schema:GetHealAmount(player, 2.0), 0, player:GetMaxHealth() ) );
	
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
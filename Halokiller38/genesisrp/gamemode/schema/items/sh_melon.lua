--[[
	� 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.name = "Melon";
ITEM.model = "models/props_junk/watermelon01.mdl";
ITEM.weight = 1;
ITEM.useText = "Eat";
ITEM.category = "Consumables"
ITEM.description = "A green fruit, it has a hard outer shell.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 10, 0, 100) );
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, 2, 600);
	player:BoostAttribute(self.name, ATB_AGILITY, 2, 600);
	player:SetCharacterData("radiation", player:GetCharacterData("radiation") + 20);
	player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 100, 0, 100) );

	
	openAura.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);
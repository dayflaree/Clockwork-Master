--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Soda";
ITEM.uniqueID = "roofie_water";
ITEM.cost = 11;
ITEM.model = "models/props_junk/popcan01a.mdl";
ITEM.weight = 0.6;
ITEM.useText = "Drink";
ITEM.business = false;
ITEM.category = "Consumables";
ITEM.description = "A blue aluminium can, it swishes when you shake it.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 100);
	player:SetHealth(math.Clamp(player:Health() + 4, 0, player:GetMaxHealth()));
	
	player:BoostAttribute(self.name, ATB_AGILITY, 1, 120);
	player:BoostAttribute(self.name, ATB_STAMINA, 1, 120);
	
	Clockwork.player:Notify(player, "That drink tasted metallic and abnormal!")
	timer.Simple( 18, function() 
		Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 180);
		Clockwork.player:Notify(player, "You have fallen unconscious!"); 
	end )
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item's functions should be edited.
function ITEM:OnEditFunctions(functions)
		for k, v in pairs(functions) do
			if (v == "Drink") then functions[k] = nil; end;
		end;
end;

ITEM:Register();
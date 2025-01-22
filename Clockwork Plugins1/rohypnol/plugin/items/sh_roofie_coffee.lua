--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Coffee";
ITEM.uniqueID = "roofie_coffee";
ITEM.cost = 14;
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.useText = "Drink"
ITEM.weight = 1.3;
ITEM.business = false;
ITEM.attributes = {Stamina = 2};
ITEM.description = "A cup of lukewarm coffee in an old, brown mug.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("empty_bagged_bottle"));
	Clockwork.player:Notify(player, "That drink tasted metallic and abnormal!")
	timer.Simple( 18, function() 
		Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 180);
		Clockwork.player:Notify(player, "You have fallen unconscious!"); 
	end )
end;

ITEM:Register();
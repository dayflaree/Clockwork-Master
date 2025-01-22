--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Beer";
ITEM.uniqueID = "roofie_beer";
ITEM.cost = 7;
ITEM.model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.weight = 0.7;
ITEM.business = false;
ITEM.attributes = {Strength = 2};
ITEM.description = "A transulcent bottle of Beer.  It has a strong, alcoholic smell to it.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
	Clockwork.player:Notify(player, "That drink tasted metallic and abnormal!")
	timer.Simple( 18, function() 
		Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 180);
		Clockwork.player:Notify(player, "You have fallen unconscious!"); 
	end )
end;

ITEM:Register();
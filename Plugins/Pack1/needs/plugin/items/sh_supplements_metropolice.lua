local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Metropolice Supplements";
ITEM.cost = 25;
ITEM.health = 3;
ITEM.model = "models/probs_misc/tobccco_box-1.mdl";
ITEM.weight = 0.6;
ITEM.category = "UU-Branded Items";
ITEM.business = false;
ITEM.description = "A large cardboard box that almost resembles that of a pre-war microwave dinner. There is a foil tin inside containing a choice of mutton, chicken or beef stew, with rice mixed into it and a full set of plastic cutlery. A small tub of assorted nuts is provided, as well as two chalky, white caffeine pills in a plastic packet. A sealed packet of crackers is separate, with a well sized tube of chocolate paste to spread onto them.";

--[[ Called when a player uses the item.
     Fills stamina and boosts stats slightly.
	 Helps give the impression of actual 'roids.
]]--
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 100);
	player:BoostAttribute(self.name, ATB_STRENGTH, 10, 7200);
	player:BoostAttribute(self.name, ATB_AGILITY, 10, 7200);
	player:BoostAttribute(self.name, ATB_DEXTERITY, 10, 7200);
	player:BoostAttribute(self.name, ATB_ENDURANCE, 10, 7200);
	player:BoostAttribute(self.name, ATB_STAMINA, 10, 7200);
	player:ProgressAttribute(ATB_AGILITY, 2, true);
	player:ProgressAttribute(ATB_DEXTERITY, 5, true);
	player:ProgressAttribute(ATB_STAMINA, 2, true);
	player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 50, 0, 100) );
end;

ITEM:Register();
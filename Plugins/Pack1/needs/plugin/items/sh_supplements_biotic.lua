local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Biotic Supplements";
ITEM.uniqueID = "biotic_supplements";
ITEM.model = "models/probs_misc/tobbcco_box-1.mdl";
ITEM.description = "A small green-looking cardboard box. Inside are six separate white-ish grey cubes. From a distance, they appear almost moist; however, on closer inspection, the surface is cracked and chafed. It smells rather off, and multiple hazard warnings cover the box — hardly appetizing...";
ITEM.weight = 0.6;
ITEM.hunger = 60;
ITEM.health = 6;
ITEM.junk = "empty_ration";
ITEM.business = false;
ITEM.category = "UU-Branded Items";

function ITEM:OnUse(player, itemEntity)
	if (player:GetFaction() != FACTION_CONSCRIPT_BIOTIC and player:GetFaction() != FACTION_VORTIGAUNT) then
		player:TakeDamage(40, player, player);
	else
		if (self("hunger", 0) > 0) then
			player:SetCharacterData("hunger", math.Clamp(player:GetCharacterData("hunger", 0) - self("hunger"), 0, 100));
		end;
		if (self("health", 0) > 0) then
			player:SetHealth(math.Clamp(player:Health() + self("health"), 0, player:GetMaxHealth()));
		end;
		if (self("junk") and type(self("junk")) == "string") then
			local item = Clockwork.item:CreateInstance(self("junk"))
			item.model = self( "model" );
			item.skin = self( "skin" );
			if (item) then
				player:GiveItem(item, true);
			else
				ErrorNoHalt("[Error] Consumable "..self("name").." attempted to give unexisting junk item "..self("junk")..".\n");
			end;
		end;
	end;
end;

ITEM:Register();
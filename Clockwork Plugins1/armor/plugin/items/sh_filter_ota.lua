local ITEM = Clockwork.item:New("filter_base");
ITEM.name = "OTA Filter";
ITEM.uniqueID = "filter_ota";
ITEM.model = "models/teebeutel/metro/objects/gasmask_filter.mdl";
ITEM.weight = 1;
ITEM.maxFilterQuality = 7200;
ITEM.useText = "Screw On";
ITEM.description = "A filter made to fit OTA masks.";
ITEM.faction = FACTION_OTA;
ITEM.refillItem = "charcoal";

function ITEM:CanPlayerWear(player, itemEntity)
	local clothes = player:GetClothesItem();
	if (player:GetFaction() == self("faction")) then
		-- Check if player already has a filter equipped
		local items = player:GetItemsByID(self("uniqueID")); local hasEquipped = false;
		for k, item in pairs(items) do
			if (item:GetData("equipped") == true) then
				hasEquipped = true;
				break;
			end;
		end;
		if (!hasEquipped) then
			return true;
		else
			Clockwork.player:Notify(player, "You are already wearing a filter!");
		end;
	else
		Clockwork.player:Notify(player, "You are not wearing a gasmask that can fit this filter!");
	end

	return false;
end;

Clockwork.item:Register(ITEM);
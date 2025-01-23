--[[
	Name: sh_battery.lua.
	Author: TJjokerR.
--]]

ITEM = openAura.item:New();
ITEM.name = "Battery Charge";
ITEM.model = "models/Items/car_battery01.mdl";
ITEM.weight = 0.2;
ITEM.useText = "Charge";
ITEM.category = "Consumables"
ITEM.batch = 1;
ITEM.cost = 2;
ITEM.access = "UA3";
ITEM.business = true;
ITEM.description = "A battery, it can charge your electronics instantly.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (openAura.player:GetAction(player) != "die") then
		player:SetCharacterData("battery", 100);
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);
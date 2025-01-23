--[[
Name: "sh_vehicle_base.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;
local ITEM = {};

ITEM.name = "Vehicle Base";
ITEM.batch = 1;
ITEM.weight = 0;
ITEM.useText = "Drive";
ITEM.category = "Vehicles";
ITEM.hornSound = "vehicles/honk.wav";
ITEM.isBaseItem = true;
ITEM.isRareItem = true;
ITEM.allowStorage = false;

-- Called when the item has initialized.
function ITEM:OnInitialize(panel)
	self.weightText = "Weightless";
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if ( !PLUGIN:SpawnVehicle(player, self) ) then
		return false;
	end;
end;

blueprint.item.Register(ITEM);
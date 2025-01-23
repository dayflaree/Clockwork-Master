--[[
Name: "sh_gasmaskfilter_charcoal.lua".
Product: "Fleshlight".
--]]

ITEM = openAura.item:New();
ITEM.name = "Gasmask Air filter";
ITEM.cost = 1;
ITEM.model = "models/teebeutel/metro/objects/gasmask_filter.mdl";
ITEM.batch = 1;
ITEM.weight = 0.1;
ITEM.access = "UAM";
ITEM.useText = "Screw On";
ITEM.business = true;
ITEM.useSound = "avoxgaming/timer/timer.wav";
ITEM.category = "Consumables";
ITEM.description = "Filters poisonous gasses to a breathable level";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if ( player:GetSharedVar("wearingRespirator") ) then
		player:SetCharacterData("filterQuality", 100);
		player:SetSharedVar( "filterQuality", 100 );
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);

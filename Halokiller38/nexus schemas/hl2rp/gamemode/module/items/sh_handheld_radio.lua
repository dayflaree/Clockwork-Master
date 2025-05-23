--[[
Name: "sh_handheld_radio.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Handheld Radio";
ITEM.cost = 20;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Communication";
ITEM.business = true;
ITEM.description = "A shiny handheld radio with a frequency tuner.";
ITEM.customFunctions = {"Frequency"};

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Frequency") then
			umsg.Start("roleplay_Frequency", player);
				umsg.String( player:GetCharacterData("frequency", "") );
			umsg.End();
		end;
	end;
end;

resistance.item.Register(ITEM);
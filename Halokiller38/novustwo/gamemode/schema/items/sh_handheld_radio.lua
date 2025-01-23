--[[
Name: "sh_handheld_radio.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Handheld Radio";
ITEM.cost = 50;
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.batch = 1;
ITEM.weight = 0.25;
ITEM.access = "T";
ITEM.business = true;
ITEM.category = "Communication"
ITEM.description = "A shiny handheld radio with a frequency tuner.";
ITEM.customFunctions = {"Frequency"};

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Frequency") then
			umsg.Start("nx_Frequency", player);
				umsg.String( player:GetCharacterData("frequency", "") );
			umsg.End();
		end;
	end;
end;

nexus.item.Register(ITEM);
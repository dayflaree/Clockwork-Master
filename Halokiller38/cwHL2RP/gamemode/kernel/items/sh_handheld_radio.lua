--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 2;
ITEM.name = "Handheld Radio";
ITEM.cost = 100;
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 1;
ITEM.category = "Reusables";
ITEM.business = true;
ITEM.batch = 1;
ITEM.isRareItem = true;
ITEM.factions = {FACTION_MPF};
ITEM.access = "v";
ITEM.description = "A shiny handheld radio with a frequency tuner.";
ITEM.customFunctions = {"Frequency"};

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item's right click should be handled.
function ITEM:OnHandleRightClick()
	return "Frequency";
end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Frequency") then
			umsg.Start("cwFrequency", player);
				umsg.String(player:GetCharacterData("Frequency", ""));
			umsg.End();
		end;
	end;
end;

Clockwork.item:Register(ITEM);
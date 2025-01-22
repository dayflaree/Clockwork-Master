
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ViewDataFileAll");
COMMAND.tip = "View the datafile of the given character, including hidden records.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local factionTable = Clockwork.player:GetFactionTable(player);
	local selectTypes, dataFileType;
	if (factionTable.recordView and factionTable.recordView >= 2) then
		selectTypes = PLUGIN.selectTypesFull;
		dataFileType = 1;
	elseif ((factionTable.loyalistRecordView and factionTable.loyalistRecordView >= 2) or Clockwork.player:HasAnyFlags(player, "L")) then
		selectTypes = PLUGIN.selectTypesLoyalist;
		dataFileType = 2;
	end;

	if (selectTypes) then
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized() and target.dataFile) then
			if (Clockwork.player:GetFactionTable(target).hasLoyalistRecord) then
				local targetCharacter = target:GetCharacter();
				if (targetCharacter) then
					PLUGIN:GetCharacterRecords(targetCharacter.key, true, selectTypes, function(recordsTable)
						Clockwork.datastream:Start(player, "OpenDataFile", {targetCharacter.key, target:Name(), target:GetFaction(), target.dataFile, recordsTable, player != target, dataFileType});
					end);
				else
					Clockwork.player:Notify(player, target:Name().." does not have a character loaded.");
				end;
			else
				Clockwork.player:Notify(player, target:Name().. " does not have a loyalist record.");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	else
		Clockwork.player:Notify(player, "You do not have permission to do this.");
	end;
end;

COMMAND:Register();

local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ViewDataFile");
COMMAND.tip = "View the datafile of the given character.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local factionTable = Clockwork.player:GetFactionTable(player);
	local selectTypes, dataFileType;
	if (factionTable.recordView and factionTable.recordView >= 1) then
		selectTypes = PLUGIN.selectTypesFull;
		dataFileType = 1;
	elseif ((factionTable.loyalistRecordView and factionTable.loyalistRecordView >= 1) or Clockwork.player:HasAnyFlags(player, "lL")) then
		selectTypes = PLUGIN.selectTypesLoyalist;
		dataFileType = 2;
	end;

	if (selectTypes) then
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized() and target.dataFile) then
			if (Clockwork.player:GetFactionTable(target).hasDataFile) then
				if (Clockwork.player:GetFactionTable(target).hasDataFile == 1 and selectTypes != 1) then
					Clockwork.player:Notify(player, "You cannot view "..target:Name().."'s datafile.");
					return;
				end;
				
				local targetCharacter = target:GetCharacter();
				if (targetCharacter) then
					PLUGIN:GetCharacterRecords(targetCharacter.key, false, selectTypes, function(recordsTable)
						Clockwork.datastream:Start(player, "OpenDataFile", {targetCharacter.key, target:Name(), target:GetFaction(), target.dataFile, recordsTable, player != target, dataFileType});
					end);
				else
					Clockwork.player:Notify(player, target:Name().." does not have a character loaded.");
				end;
			else
				Clockwork.player:Notify(player, target:Name().. " does not have a datafile.");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	else
		Clockwork.player:Notify(player, "You do not have permission to do this.");
	end;
end;

COMMAND:Register();
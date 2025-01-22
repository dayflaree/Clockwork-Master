
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.datastream:Hook("OpenDataFile", function(data)
	--[[
		data[1] = targetKey
		data[2] = targetName
		data[3] = targetFaction
		data[4] = dataFile
		data[5] = records
		data[6] = addButtons
		data[7] = dataFileType
	]]
	if (PLUGIN.dataFile and PLUGIN.dataFile:IsValid()) then
		PLUGIN.dataFile:Close();
		PLUGIN.dataFile:Remove();
	end;
	
	if (data[7] == 1) then
		PLUGIN.dataFile = vgui.Create("cwCivilRecord");
	elseif (data[7] == 2) then
		PLUGIN.dataFile = vgui.Create("cwLoyalistRecord");
	else
		return;
	end;
	PLUGIN.dataFile:PopulateRecords(data[1], data[2], data[5], data[6]);
	PLUGIN.dataFile:PopulateData(data[1], data[2], data[3], data[4]);
	PLUGIN.dataFile:MakePopup();
	
	gui.EnableScreenClicker(true);
end);

Clockwork.datastream:Hook("AddEntryToRecords", function(data)
	if (PLUGIN.dataFile and PLUGIN.dataFile:IsValid()) then
		PLUGIN.dataFile:AddData(data, true);
	end;
end);
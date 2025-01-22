
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.datastream:Hook("EditNotes", function(data)
	if (PLUGIN.notesPanel and PLUGIN.notesPanel:IsValid()) then
		PLUGIN.notesPanel:Close();
		PLUGIN.notesPanel:Remove();
	end;
	
	PLUGIN.notesPanel = vgui.Create("cwNotes");
	PLUGIN.notesPanel:Populate(data[1]);
	PLUGIN.notesPanel:MakePopup();
	
	gui.EnableScreenClicker(true);
end);
--[[
Name: "cl_auto.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

BLUEPRINT:IncludePrefixed("sh_auto.lua");

BLUEPRINT:HookDataStream("ViewPaper", function(data)
	if ( IsValid( data[1] ) ) then
		if ( IsValid(PLUGIN.paperPanel) ) then
			PLUGIN.paperPanel:Close();
			PLUGIN.paperPanel:Remove();
		end;
		
		if ( !data[3] ) then
			local uniqueID = data[2];
			
			if ( PLUGIN.paperIDs[uniqueID] ) then
				data[3] = PLUGIN.paperIDs[uniqueID];
			else
				data[3] = "Error!";
			end;
		else
			local uniqueID = data[2];
			
			PLUGIN.paperIDs[uniqueID] = data[3];
		end;
		
		PLUGIN.paperPanel = vgui.Create("bp_ViewPaper");
		PLUGIN.paperPanel:SetEntity( data[1] );
		PLUGIN.paperPanel:Populate( data[3] );
		PLUGIN.paperPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

usermessage.Hook("bp_EditPaper", function(msg)
	local entity = msg:ReadEntity();
	
	if ( IsValid(entity) ) then
		if ( IsValid(PLUGIN.paperPanel) ) then
			PLUGIN.paperPanel:Close();
			PLUGIN.paperPanel:Remove();
		end;
		
		PLUGIN.paperPanel = vgui.Create("bp_EditPaper");
		PLUGIN.paperPanel:SetEntity(entity);
		PLUGIN.paperPanel:Populate();
		PLUGIN.paperPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);
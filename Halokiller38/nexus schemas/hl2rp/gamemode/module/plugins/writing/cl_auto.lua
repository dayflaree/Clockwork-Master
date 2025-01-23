--[[
Name: "cl_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

RESISTANCE:HookDataStream("ViewPaper", function(data)
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
		
		PLUGIN.paperPanel = vgui.Create("roleplay_ViewPaper");
		PLUGIN.paperPanel:SetEntity( data[1] );
		PLUGIN.paperPanel:Populate( data[3] );
		PLUGIN.paperPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

usermessage.Hook("roleplay_EditPaper", function(msg)
	local entity = msg:ReadEntity();
	
	if ( IsValid(entity) ) then
		if ( IsValid(PLUGIN.paperPanel) ) then
			PLUGIN.paperPanel:Close();
			PLUGIN.paperPanel:Remove();
		end;
		
		PLUGIN.paperPanel = vgui.Create("roleplay_EditPaper");
		PLUGIN.paperPanel:SetEntity(entity);
		PLUGIN.paperPanel:Populate();
		PLUGIN.paperPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);
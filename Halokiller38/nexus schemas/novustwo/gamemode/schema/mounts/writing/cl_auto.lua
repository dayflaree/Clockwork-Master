--[[
Name: "cl_auto.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

NEXUS:HookDataStream("ViewPaper", function(data)
	if ( IsValid( data[1] ) ) then
		if ( IsValid(MOUNT.paperPanel) ) then
			MOUNT.paperPanel:Close();
			MOUNT.paperPanel:Remove();
		end;
		
		if ( !data[3] ) then
			local uniqueID = data[2];
			
			if ( MOUNT.paperIDs[uniqueID] ) then
				data[3] = MOUNT.paperIDs[uniqueID];
			else
				data[3] = "Error!";
			end;
		else
			local uniqueID = data[2];
			
			MOUNT.paperIDs[uniqueID] = data[3];
		end;
		
		MOUNT.paperPanel = vgui.Create("nx_ViewPaper");
		MOUNT.paperPanel:SetEntity( data[1] );
		MOUNT.paperPanel:Populate( data[3] );
		MOUNT.paperPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

usermessage.Hook("nx_EditPaper", function(msg)
	local entity = msg:ReadEntity();
	
	if ( IsValid(entity) ) then
		if ( IsValid(MOUNT.paperPanel) ) then
			MOUNT.paperPanel:Close();
			MOUNT.paperPanel:Remove();
		end;
		
		MOUNT.paperPanel = vgui.Create("nx_EditPaper");
		MOUNT.paperPanel:SetEntity(entity);
		MOUNT.paperPanel:Populate();
		MOUNT.paperPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);
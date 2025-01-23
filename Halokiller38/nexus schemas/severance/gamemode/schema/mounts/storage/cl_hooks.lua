--[[
Name: "cl_hooks.lua".
Product: "Severance".
--]]

local MOUNT = MOUNT;

-- Called when an entity's target ID HUD should be painted.
function MOUNT:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	
	if ( nexus.entity.IsPhysicsEntity(entity) ) then
		local model = string.lower( entity:GetModel() );
		
		if ( self.containers[model] ) then
			if (entity:GetNetworkedString("sh_Name") != "") then
				info.y = NEXUS:DrawInfo(entity:GetNetworkedString("sh_Name"), info.x, info.y, colorTargetID, info.alpha);
			else
				info.y = NEXUS:DrawInfo(self.containers[model][2], info.x, info.y, colorTargetID, info.alpha);
			end;
			
			info.y = NEXUS:DrawInfo("You can put stuff inside it.", info.x, info.y, colorWhite, info.alpha);
		end;
	end;
end;

-- Called when an entity's menu options are needed.
function MOUNT:GetEntityMenuOptions(entity, options)
	if ( nexus.entity.IsPhysicsEntity(entity) ) then
		local model = string.lower( entity:GetModel() );
		
		if ( self.containers[model] ) then
			options["Open"] = "nx_containerOpen";
		end;
	end;
end;

-- Called when the local player's storage is rebuilt.
function MOUNT:PlayerStorageRebuilt(panel, categories)
	if (panel.name == "Container") then
		local entity = nexus.storage.GetEntity();
		
		if (IsValid(entity) and entity.message) then
			local messageForm = vgui.Create("DForm", panel);
			local helpText = messageForm:Help(entity.message);
			
			messageForm:SetPadding(5);
			messageForm:SetName("Message");
			helpText:SetFont("Default");
			
			panel:AddItem(messageForm);
		end;
	end;
end;
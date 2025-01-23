--[[
Name: "cl_hooks.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's target ID HUD should be painted.
function PLUGIN:HUDPaintEntityTargetID(entity, info)
	local colorWhite = blueprint.design.GetColor("white");
	
	if ( blueprint.entity.IsPhysicsEntity(entity) ) then
		local model = string.lower( entity:GetModel() );
		
		if ( self.containers[model] ) then
			if (entity:GetNetworkedString("sh_Name") != "") then
				info.y = BLUEPRINT:DrawInfo(entity:GetNetworkedString("sh_Name"), info.x, info.y, colorWhite, info.alpha);
			end;
		end;
	end;
end;

-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	if ( blueprint.entity.IsPhysicsEntity(entity) ) then
		local model = string.lower( entity:GetModel() );
		
		if ( self.containers[model] ) then
			options["Open"] = "bp_containerOpen";
		end;
	end;
end;

-- Called when the local player's storage is rebuilt.
function PLUGIN:PlayerStorageRebuilt(panel, categories)
	if (panel.name == "Container") then
		local entity = blueprint.storage.GetEntity();
		
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
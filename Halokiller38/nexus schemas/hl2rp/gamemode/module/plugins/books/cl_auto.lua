--[[
Name: "cl_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

usermessage.Hook("roleplay_ViewBook", function(msg)
	local entity = msg:ReadEntity();
	
	if ( IsValid(entity) ) then
		local index = entity:GetSharedVar("sh_Index");
		
		if (index != 0) then
			local itemTable = resistance.item.Get(index);
			
			if (itemTable and itemTable.bookInformation) then
				if ( IsValid(PLUGIN.bookPanel) ) then
					PLUGIN.bookPanel:Close();
					PLUGIN.bookPanel:Remove();
				end;
				
				PLUGIN.bookPanel = vgui.Create("roleplay_ViewBook");
				PLUGIN.bookPanel:SetEntity(entity);
				PLUGIN.bookPanel:Populate(itemTable);
				PLUGIN.bookPanel:MakePopup();
			end;
		end;
	end;
end);
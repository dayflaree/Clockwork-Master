local PLUGIN = PLUGIN;

--[[
-- Called when the menu's items should be adjusted.
function PLUGIN:MenuItemsAdd(menuItems)
	if (Clockwork.Client:IsSuperAdmin()) then
		menuItems:Add("ItemBuilder", "cwItemMainMenu", "Access the itembuilder menu.");
	end;
end;
]]--
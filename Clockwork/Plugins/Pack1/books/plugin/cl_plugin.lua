--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

--[[
	data = {
		[1] = item's unique ID,
		[2] = is viewing from inventory (bool),
		[3] = the book entity (or null if viewing from inventory)
	}
--]]
Clockwork.datastream:Hook("cwViewBook", function(data)
	local itemTable = Clockwork.item:FindByID(data[1])
		
	if (itemTable and itemTable.bookInformation) then
		if (IsValid(PLUGIN.bookPanel)) then
			PLUGIN.bookPanel:Close();
			PLUGIN.bookPanel:Remove();
		end;
		PLUGIN.bookPanel = vgui.Create("cwViewBook");
		
		PLUGIN.bookPanel:SetEntity(data[3]);
		PLUGIN.bookPanel:Populate(itemTable, data[2]);
		PLUGIN.bookPanel:MakePopup();
	end;
end);
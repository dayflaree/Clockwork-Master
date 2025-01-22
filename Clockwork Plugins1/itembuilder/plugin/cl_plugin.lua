local PLUGIN = PLUGIN;

local Clockwork = Clockwork;

Clockwork.datastream:Hook("ItemBuilder", function(data)
	if (IsValid(PLUGIN.itemPanel)) then
		PLUGIN.itemPanel:Close();
		PLUGIN.itemPanel:Remove();
	end;
	
	PLUGIN.itemPanel = vgui.Create("cwItemMainMenu");
	PLUGIN.itemPanel:Populate(data);
	PLUGIN.itemPanel:MakePopup();
		
	gui.EnableScreenClicker(true);
end);

function PLUGIN:RegisterItem(data)
	local ITEM;
	local itemCheck = Clockwork.item:FindByID(data.name);
	if (itemCheck) then
		if (!itemCheck.customnumber) then
			return false
		else
			ITEM = itemCheck;
			print("[IB] '"..ITEM.name.."' edited...")
		end;
	else
		ITEM = Clockwork.item:New();
	end;

	ITEM.name = data.name;
	ITEM.cost = tonumber(data.cost);
	ITEM.model = data.model;
	ITEM.weight = tonumber(data.weight);
	ITEM.access = data.access
	ITEM.useText = data.useText;
	ITEM.category = data.category;
	ITEM.description = data.description;
			
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	if (!itemCheck) then
		Clockwork.item:Register(ITEM)
		print("[IB] '"..ITEM.name.."' loaded...")
	end;
end;

Clockwork.datastream:Hook("RegisterItem", function(data)
	PLUGIN:RegisterItem(data)
end);

Clockwork.datastream:Hook("GiveStartItems", function(data)
	for k, v in ipairs(data) do
		PLUGIN:RegisterItem(v)
	end;
end);
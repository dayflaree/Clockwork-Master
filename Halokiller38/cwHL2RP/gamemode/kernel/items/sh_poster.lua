--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 1;
ITEM.name = "Poster";
ITEM.cost = 10;
ITEM.model = "models/props_c17/paper01.mdl";
ITEM.weight = 0.5;
ITEM.useText = "Edit";
ITEM.business = true;
ITEM.batch = 1;
ITEM.category = "Reusables";
ITEM.description = "A poster that can be written on and posted on walls and other surfaces.";

--[[ Add the data type for storing the notepad text. --]]
ITEM:AddData("Text", "");
ITEM:AddData("Owner", "");
ITEM:AddData("UseText", "Write", true);
ITEM:AddQueryProxy("useText", "UseText", true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (self:GetData("Text") == "") then
		Clockwork:StartDataStream(player, "Poster", {
			text = self:GetData("Text"),
			readOnly = false,
			itemID = self("itemID")
		});
	else
		Clockwork:StartDataStream(player, "Poster", {
			text = self:GetData("Text"),
			readOnly = true,
			itemID = self("itemID")
		});
	end;
	
	Clockwork.player:SetMenuOpen(player, false);
	return false;
end;

--Called when a player orders the item.
function ITEM:OnOrder(player, entity)
	
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

function ITEM:CanPickup(player, bQuickUse, entity)
	if (!bQuickUse) then
		Clockwork.player:Notify(player, "You cannot tear down that poster!");
		return false;
	end;
end;

if (CLIENT) then
	Clockwork:HookDataStream("Poster", function(data)
		local itemID = data.itemID;
		local text = data.text;
		local readOnly = data.readOnly;
		
		local panel = vgui.Create("cwBasicEditbox");
		panel:Populate("Create Poster", text);
		panel:ReadOnly(readOnly);
		panel:SetCallback(function(text)
			Clockwork:StartDataStream(
				"Poster", {
					itemID = itemID,
					text = string.sub(text, 0, 500)
				}
			);
		end);
		panel:MakePopup();
		
		gui.EnableScreenClicker(true);
		
	end);
else
	Clockwork:HookDataStream("Poster", function(player, data)
		local itemID = data.itemID;
		local text = data.text;
		
		local itemTable = Clockwork.item:FindInstance(itemID);
		if (itemTable) then
			itemTable:SetData("Text", text);
			itemTable:SetData("UseText", "Read");
		end;
	end);
end;
		
Clockwork.item:Register(ITEM);
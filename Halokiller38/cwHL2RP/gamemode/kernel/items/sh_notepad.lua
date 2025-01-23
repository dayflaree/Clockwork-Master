--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 1;
ITEM.name = "Notepad";
ITEM.cost = 15;
ITEM.model = "models/props_lab/clipboard.mdl";
ITEM.weight = 0.5;
ITEM.useText = "Edit";
ITEM.business = true;
ITEM.batch = 1;
ITEM.category = "Reusables";
ITEM.description = "A clean and professional notepad with a cardboard backing.";

--[[ Add the data type for storing the notepad text. --]]
ITEM:AddData("Text", "");
ITEM:AddData("Hint", "", true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	Clockwork:StartDataStream(player, "Notepad", {
		definition = Clockwork.item:GetDefinition(self),
		text = self:GetData("Text")
	});
	
	Clockwork.player:SetMenuOpen(player, false);
	return false;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		local clientSideInfo = "";
		local itemHint = self:GetData("Hint");
		
		if (itemHint != "") then
			clientSideInfo = Clockwork:AddMarkupLine(clientSideInfo, itemHint);
		end;
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
	
	Clockwork:HookDataStream("Notepad", function(data)
		local itemTable = Clockwork.item:CreateInstance(
			data.definition.index, data.definition.itemID,
			data.definition.data
		);

		local panel = vgui.Create("cwEditbox");
		panel:Populate(data.text, itemTable);
		panel:SetCallback(function(text, itemTable)
			Clockwork:StartDataStream(
				"Notepad", {
					itemID = itemTable("itemID"),
					index = itemTable("index"),
					text = string.sub(text, 0, 500)
				}
			);
		end);
		panel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end);
	
else

	Clockwork:HookDataStream("Notepad", function(player, data)
		local itemTable = Clockwork.item:FindInstance(data.itemID);
		if (type(data.text) == "string" and itemTable) then
			itemTable:SetData("Text", string.sub(data.text, 0, 500));
			itemTable:SetData("Hint", string.sub(data.text, 0, 32));
		end;
	end);
end;

Clockwork.item:Register(ITEM);
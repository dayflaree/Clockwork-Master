include("sh_inventory.lua")

INVENTORY.MYITEMS = {}

function RefreshInventory(handler, id, encoded, decoded)
	INVENTORY.MYITEMS = decoded[1]
end
datastream.Hook("RefreshInventory", RefreshInventory)

function PrintInventory(ply, cmd, args)
	PrintTable(INVENTORY.MYITEMS)
end
concommand.Add("PrintInventory", PrintInventory)

function ShowInventory()
	Inventory = vgui.Create("DFrame")
	Inventory:SetPos(50, 50)
	Inventory:SetSize(300, 345)
	Inventory:SetTitle("Inventory")
	Inventory:SetVisible(true)
	Inventory:SetDraggable(true)
	Inventory:ShowCloseButton(true)
	Inventory:MakePopup()
	
	local DropItemButton = vgui.Create("DButton", Inventory)
	DropItemButton:SetPos(5, 30)
	DropItemButton:SetTall(20)
	DropItemButton:SetWide(290)
	DropItemButton:SetText("Drop Current Weapon")
	DropItemButton.DoClick = function()
		RunConsoleCommand("INVENTORY_DropCurrentWeapon")
	end
	
	local ItemList = vgui.Create("DPanelList", Inventory)
	ItemList:SetPos(5, 55)
	ItemList:SetSize(Inventory:GetWide() - 10, Inventory:GetTall() - 65)
	ItemList:SetSpacing(5)
	ItemList:SetPadding(5)
	ItemList:EnableHorizontal(false)
	ItemList:EnableVerticalScrollbar(true)
	
	//ItemList:AddItem(DropItemButton)
	
	for k, v in pairs(INVENTORY.MYITEMS) do
		if v > 0 then
			local Container = vgui.Create("DPanel")
			Container:SetTall(80)
			Container:SetWide(280)
			
			local SpawnIcon = vgui.Create("SpawnIcon", Container)
			SpawnIcon:SetPos(8, 8)
			SpawnIcon:SetIconSize(64)
			SpawnIcon:SetModel(INVENTORY.ITEMS[k].Model)
			SpawnIcon:SetSkin(INVENTORY.ITEMS[k].Skin)
			SpawnIcon.DoClick = function()
				local OptionMenu = DermaMenu()
					OptionMenu:AddOption("Use Item", function() LocalPlayer():ConCommand("INVENTORY_UseItem "..k) end)
					OptionMenu:AddOption("Drop Item", function() LocalPlayer():ConCommand("INVENTORY_DropItem "..k) end)
					OptionMenu:AddOption("Cancel", function() end)
				OptionMenu:Open()
			end
			
			local ItemName = vgui.Create("DLabel", Container)
			ItemName:SetPos(78, 13)
			ItemName:SetText("Name: "..INVENTORY.ITEMS[k].Name)
			ItemName:SizeToContents()
			
			local ItemDescription = vgui.Create("DLabel", Container)
			ItemDescription:SetPos(78, 33)
			ItemDescription:SetText("Description: "..INVENTORY.ITEMS[k].Description)
			ItemDescription:SizeToContents()
			
			local ItemDescription = vgui.Create("DLabel", Container)
			ItemDescription:SetPos(78, 53)
			ItemDescription:SetText("Quantity: "..v)
			ItemDescription:SizeToContents()
			
			ItemList:AddItem(Container)
		end
	end
end
concommand.Add("ShowInventory", ShowInventory)

function HideInventory()
	if Inventory then
		Inventory:Remove()
	end
end
concommand.Add("HideInventory", HideInventory)
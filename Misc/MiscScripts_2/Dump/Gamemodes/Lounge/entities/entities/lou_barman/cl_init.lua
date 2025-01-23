include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:BuildBonePositions(NumBones, NumPhysBones)
end

function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn
end

function ENT:DoRagdollBone(PhysBoneNum, BoneNum)
end

function lou_barman_menu_hook(um)
	Inventory = vgui.Create("DFrame")
	Inventory:SetPos(50, 50)
	Inventory:SetSize(300, 345)
	Inventory:SetTitle("James")
	Inventory:SetVisible(true)
	Inventory:SetDraggable(true)
	Inventory:ShowCloseButton(true)
	Inventory:MakePopup()
	
	local ItemList = vgui.Create("DPanelList", Inventory)
	ItemList:SetPos(5, 55)
	ItemList:SetSize(Inventory:GetWide() - 10, Inventory:GetTall() - 65)
	ItemList:SetSpacing(5)
	ItemList:SetPadding(5)
	ItemList:EnableHorizontal(false)
	ItemList:EnableVerticalScrollbar(true)
	
	local Items = {"beer", "vodka"}
	
	for k, v in pairs(Items) do
		local Container = vgui.Create("DPanel")
		Container:SetTall(80)
		Container:SetWide(280)
		
		local SpawnIcon = vgui.Create("SpawnIcon", Container)
		SpawnIcon:SetPos(8, 8)
		SpawnIcon:SetIconSize(64)
		SpawnIcon:SetModel(INVENTORY.ITEMS[v].Model)
		SpawnIcon.DoClick = function()
			local OptionMenu = DermaMenu()
				OptionMenu:AddOption("Purchase Item", function() LocalPlayer():ConCommand("INVENTORY_BuyItem "..v) end)
				OptionMenu:AddOption("Cancel", function() end)
			OptionMenu:Open()
		end
			
		local ItemName = vgui.Create("DLabel", Container)
		ItemName:SetPos(78, 13)
		ItemName:SetText("Name: "..INVENTORY.ITEMS[v].Name)
		ItemName:SizeToContents()
			
		local ItemDescription = vgui.Create("DLabel", Container)
		ItemDescription:SetPos(78, 33)
		ItemDescription:SetText("Description: "..INVENTORY.ITEMS[v].Description)
		ItemDescription:SizeToContents()
			
		local ItemDescription = vgui.Create("DLabel", Container)
		ItemDescription:SetPos(78, 53)
		ItemDescription:SetText("Price: "..INVENTORY.ITEMS[v].Price)
		ItemDescription:SizeToContents()
			
		ItemList:AddItem(Container)
	end
end
usermessage.Hook("lou_barman_menu", lou_barman_menu_hook)

function lou_barman_speak_hook(um)
	local name = um:ReadString()
	local text = um:ReadString()
	//if not Speak then Speak = vgui.Create("HTML") end
	//Speak:SetPos(-10, -10)
	//Speak:SetSize(0, 0)
	//Speak:OpenURL("http://say.expressivo.com/eric/"..text)
	chat.AddText(Color(200, 0, 0, 255), name, Color(255, 255, 255, 255), ": "..text)
end
usermessage.Hook("lou_barman_speak", lou_barman_speak_hook)
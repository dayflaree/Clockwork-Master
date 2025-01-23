local LPOffer = {Money = 0,Items = {}}

local Temp_Inventory = {}

local Temp_TradePlayer = LocalPlayer()

local Confirmed = false

function CL_TradePlayer( umsg )
	if GUI_Trade_Frame != nil && GUI_Trade_Frame:IsValid() then
		GUI_Trade_Frame:Remove()
	end
	Temp_TradePlayer = umsg:ReadEntity()
	GUI_TradeMenu()
	if GUI_Shop_Frame != nil && GUI_Shop_Frame:IsValid() then
		GUI_Shop_Frame:Remove()
	end
end
usermessage.Hook('OCRP_TradePlayer', CL_TradePlayer);

function CL_EndTrade( umsg )
	for _,data in pairs(LPOffer.Items) do
		if  data.Amount > 0 &&  data.Item != "empty"  then
			LP_RemoveItemFromOffer(data.Item,data.Amount)
		end
	end
	LPOffer = {Money = 0,Items = {}}
	if GUI_Trade_Frame != nil && GUI_Trade_Frame:IsValid() then
		GUI_Trade_Frame:Remove()
	end
end
usermessage.Hook('OCRP_EndTrade', CL_EndTrade);

function CL_RecieveTradeItem( umsg )
	local money = umsg:ReadLong()
	local slot = umsg:ReadLong()
	local item = umsg:ReadString()
	local amount = umsg:ReadLong()
	local otherConfirmed = umsg:ReadBool()
	Confirmed = false
	
	OCRP_TradingInfo.Money = money
	
	OCRP_TradingInfo.Items[slot] = {Item = item,Amount = amount}
	
	if GUI_Trade_Frame != nil && GUI_Trade_Frame:IsValid() then
		GUI_OPMoney_Label:SetText("$"..money)
		if otherConfirmed == true then
			GUI_Confirm_Trade:SetText("Confirm Trade - Other player has confirmed")
		else
			GUI_Confirm_Trade:SetText("Confirm Trade")
		end
		GUI_Rebuild_OtherPlayer_TradeMenu(GUI_Trade_Frame)
	end
end
usermessage.Hook('OCRP_RecieveTradeItem', CL_RecieveTradeItem);

function CL_SendTradeItem( ply,money,item,amount,slot )
	Confirmed = false
	RunConsoleCommand("OCRP_SendTrade",tonumber(ply:EntIndex()),tonumber(money),tostring(item),tonumber(amount),tonumber(slot))
end


	
function GUI_TradeMenu()
	if GUI_Trade_Frame != nil && GUI_Trade_Frame:IsValid() then return end
	if GUI_Main_Frame then if GUI_Main_Frame:IsValid() then return false end end
	OCRP_TradingInfo = {Money = 0,Items = {}}
	LPOffer = {Money = 0,Items = {}}
	
	GUI_Trade_Frame = vgui.Create("DFrame")
	GUI_Trade_Frame:SetTitle("")
	GUI_Trade_Frame:SetSize(768 ,580)
	GUI_Trade_Frame:Center()
	GUI_Trade_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Trade_Frame:GetWide(),GUI_Trade_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Trade_Frame:GetWide()-2,GUI_Trade_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UIBold")
								local x,y = surface.GetTextSize("Trade Menu")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Trade Menu")
							end
	GUI_Trade_Frame:MakePopup()
	GUI_Trade_Frame:ShowCloseButton(false)
	
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Trade_Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(738,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()			
								GUI_Trade_Frame:Remove()
								RunConsoleCommand("OCRP_EndTrade",tonumber(Temp_TradePlayer:EntIndex()))
								for _,data in pairs(LPOffer.Items) do
									if  data.Amount > 0 &&  data.Item != "empty"  then
										LP_RemoveItemFromOffer(data.Item,data.Amount)
									end
								end
								LPOffer = {Money = 0,Items = {}}
							end
	
	local GUI_LPInv_Panel_List = vgui.Create("DPanelList")
	GUI_LPInv_Panel_List:SetParent(GUI_Trade_Frame)
	GUI_LPInv_Panel_List:SetSize(746,240)
	GUI_LPInv_Panel_List:SetPos(11,300)
	GUI_LPInv_Panel_List.Paint = function()
								--draw.RoundedBox(8,0,0,GUI_LPInv_Panel_List:GetWide(),GUI_LPInv_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
								end
	GUI_LPInv_Panel_List:SetPadding(7.5)
	GUI_LPInv_Panel_List:SetSpacing(5)
	GUI_LPInv_Panel_List:EnableHorizontal(3)
	GUI_LPInv_Panel_List:EnableVerticalScrollbar(true)
	
	Temp_Inventory = OCRP_Inventory
	
	GUI_Rebuild_LocalPlayer_TradeMenu(GUI_Trade_Frame)
	GUI_Rebuild_OtherPlayer_TradeMenu(GUI_Trade_Frame)
	GUI_Rebuild_TradeInventory(GUI_LPInv_Panel_List)

	GUI_Confirm_Trade = vgui.Create("DButton")
	GUI_Confirm_Trade:SetParent(GUI_Trade_Frame)
	GUI_Confirm_Trade:SetPos(10,550)
	GUI_Confirm_Trade:SetSize(748,20)
	GUI_Confirm_Trade:SetTextColor(Color(0,0,0,255))
	GUI_Confirm_Trade:SetText("Confirm Trade")
	
	GUI_Confirm_Trade.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Confirm_Trade:GetWide(),GUI_Confirm_Trade:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Confirm_Trade:GetWide()-2,GUI_Confirm_Trade:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
							
	GUI_Confirm_Trade.Think = function()
									if Confirmed then
										GUI_Confirm_Trade:SetTextColor(Color(155,155,155,255))
									else
										GUI_Confirm_Trade:SetTextColor(Color(255,255,255,255)) 
									end
								end
	GUI_Confirm_Trade.DoClick = function()
									if !Confirmed then
										Confirmed = true
										RunConsoleCommand("OCRP_ConfirmTrade",tonumber(Temp_TradePlayer:EntIndex()))
									end
								end	
	GUI_LPMoney_Label_Entry = vgui.Create("DTextEntry")
	GUI_LPMoney_Label_Entry:SetFont("UIBold")
	GUI_LPMoney_Label_Entry:SetValue(OCRP_TradingInfo.Money)
	GUI_LPMoney_Label_Entry:SetSize(150,15)
	GUI_LPMoney_Label_Entry:SetEditable(true)
	GUI_LPMoney_Label_Entry:SetUpdateOnType(true)
	GUI_LPMoney_Label_Entry:SetNumeric(true)
	GUI_LPMoney_Label_Entry:SetParent(GUI_Trade_Frame)
	GUI_LPMoney_Label_Entry:SetPos(42 ,270)	

	
	GUI_LPMoney_Label_Entry.OnValueChanged = function()
												local price = (GUI_LPMoney_Label_Entry:GetValue())
												if price <= tonumber(LocalPlayer().Wallet) then
													LPOffer.Money = price
												else
													LPOffer.Money = LocalPlayer().Wallet
													GUI_LPMoney_Label_Entry:SetValue(LocalPlayer().Wallet)
												end
												for _,data in pairs(LPOffer.Items) do 
													if data.Item == item then
														CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,data.Item,data.Amount,_)
														return
													end
												end
												CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,nil,nil,nil)
											end	

	GUI_LPMoney_Label_Entry.OnEnter = function()
												local price = tonumber(GUI_LPMoney_Label_Entry:GetValue())
												if price <= tonumber(LocalPlayer().Wallet) then
													LPOffer.Money = price
												else
													LPOffer.Money = LocalPlayer().Wallet
													GUI_LPMoney_Label_Entry:SetValue(LocalPlayer().Wallet)
												end
												for _,data in pairs(LPOffer.Items) do 
													if data.Item == item then
														CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,data.Item,data.Amount,_)
														return
													end
												end
												CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,nil,nil,nil)
											end												
	
	GUI_OPMoney_Label = vgui.Create("DLabel")
	GUI_OPMoney_Label:SetColor(Color(255,255,255,255))
	GUI_OPMoney_Label:SetFont("UIBold")
	GUI_OPMoney_Label:SetText("$"..OCRP_TradingInfo.Money)
	GUI_OPMoney_Label:SetSize(200,15)
	GUI_OPMoney_Label:SetParent(GUI_Trade_Frame)
	GUI_OPMoney_Label:SetPos(576 ,270)	
end

function GUI_Rebuild_LocalPlayer_TradeMenu(parent)
	if GUI_LPTrade_Panel_List != nil && GUI_LPTrade_Panel_List:IsValid() then
		GUI_LPTrade_Panel_List:Clear()
	else
		GUI_LPTrade_Panel_List = vgui.Create("DPanelList")
		GUI_LPTrade_Panel_List:SetParent(parent)
		GUI_LPTrade_Panel_List:SetSize(366,240)
		GUI_LPTrade_Panel_List:SetPos(11,30)
		GUI_LPTrade_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_LPTrade_Panel_List:GetWide(),GUI_LPTrade_Panel_List:GetTall(),Color( 60, 60, 60, 155))
									end
		GUI_LPTrade_Panel_List:SetPadding(7.5)
		GUI_LPTrade_Panel_List:SetSpacing(5)
		GUI_LPTrade_Panel_List:EnableHorizontal(3)
		GUI_LPTrade_Panel_List:EnableVerticalScrollbar(true)
	end
	
	local itemstbl = LPOffer.Items
	
	if itemstbl != nil then
		GUI_Rebuild_Trade_Items(GUI_LPTrade_Panel_List,itemstbl,true)
	end
	
	return GUI_LPTrade_Panel_List
end

function GUI_Rebuild_OtherPlayer_TradeMenu(parent)
	if GUI_OPTrade_Panel_List != nil && GUI_OPTrade_Panel_List:IsValid() then
		GUI_OPTrade_Panel_List:Clear()
	else
		GUI_OPTrade_Panel_List = vgui.Create("DPanelList")
		GUI_OPTrade_Panel_List:SetParent(parent)
		GUI_OPTrade_Panel_List:SetSize(366,240)
		GUI_OPTrade_Panel_List:SetPos(388,30)
		GUI_OPTrade_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_OPTrade_Panel_List:GetWide(),GUI_OPTrade_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									
										surface.SetFont("UIBold")
										local x,y = surface.GetTextSize("Trading with "..Temp_TradePlayer:Nick())
										surface.SetTextPos(GUI_OPTrade_Panel_List:GetWide()/2 - x/2,GUI_OPTrade_Panel_List:GetTall()/2 -y/2)
										surface.DrawText("Trading with "..Temp_TradePlayer:Nick())
									end
		GUI_OPTrade_Panel_List:SetPadding(7.5)
		GUI_OPTrade_Panel_List:SetSpacing(5)
		GUI_OPTrade_Panel_List:EnableHorizontal(3)
		GUI_OPTrade_Panel_List:EnableVerticalScrollbar(true)
		
	end
	
	local itemstbl = OCRP_TradingInfo.Items
	
	if itemstbl != nil then
		GUI_Rebuild_Trade_Items(GUI_OPTrade_Panel_List,itemstbl,false)
	end
		
	return GUI_OPTrade_Panel_List
end


function GUI_Rebuild_Trade_Items(parent,itemstbl,bool_local)

	local Inv_Icon_ent = ents.Create("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	for _,data in pairs(itemstbl) do
		if data.Item != "empty" && data.Amount != 0  then
			local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
			GUI_Inv_Item_Panel:SetParent(parent)
			
			if bool_local then
				GUI_Inv_Item_Panel:SetSize(100,120)
			else
				GUI_Inv_Item_Panel:SetSize(100,100)
			end
			
			GUI_Inv_Item_Panel:SetPos(0,0)
			GUI_Inv_Item_Panel:SetSpacing(5)
			GUI_Inv_Item_Panel.Paint = function()
											draw.RoundedBox(8,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
			local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
			GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Icon:SetPos(0,0)
			GUI_Inv_Item_Icon:SetSize(100,100)
			
			GUI_Inv_Item_Icon:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
			
			Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
			
			if GAMEMODE.OCRP_Items[data.Item].Angle != nil then
				GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[data.Item].Angle)
			end
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			GUI_Inv_Item_Icon:SetLookAt(center)
			GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
			local GUI_Inv_Item_Name = vgui.Create("DLabel")
			GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Name:SetFont("UIBold")
			GUI_Inv_Item_Name:SetText(GAMEMODE.OCRP_Items[data.Item].Name)
			GUI_Inv_Item_Name:SizeToContents()
			GUI_Inv_Item_Name:SetParent(GUI_Inv_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[data.Item].Name)
			
			GUI_Inv_Item_Name:SetPos(50 - x/2,10-y/2)	
		
			if data.Amount > 1 then
				local GUI_Inv_Item_Amt = vgui.Create("DLabel")
				GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
				GUI_Inv_Item_Amt:SetFont("UIBold")
				GUI_Inv_Item_Amt:SetText("x"..data.Amount)
				GUI_Inv_Item_Amt:SizeToContents()
				GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("x"..data.Amount)
				
				GUI_Inv_Item_Amt:SetPos(50 - x/2,90-y/2)
			end			
			
			
			if bool_local then
			
				local GUI_Inv_Item_Remove = vgui.Create("DButton")
				GUI_Inv_Item_Remove:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Remove:SetPos(5,105)
				GUI_Inv_Item_Remove:SetSize(90,10)
				GUI_Inv_Item_Remove:SetText("")
				GUI_Inv_Item_Remove.Paint = function()
												draw.RoundedBox(4,0,0,GUI_Inv_Item_Remove:GetWide(),GUI_Inv_Item_Remove:GetTall(),Color( 60, 60, 60, 155 ))
												draw.RoundedBox(4,1,1,GUI_Inv_Item_Remove:GetWide()-1,GUI_Inv_Item_Remove:GetTall()-1,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
												local struc = {}
												struc.pos = {}
												struc.pos[1] = 45 -- x pos
												struc.pos[2] = 5 -- y pos
												struc.color = Color(255,255,255,255) -- Red
												struc.text = "Remove" -- Text
												struc.font = "UIBold" -- Font
												struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
												struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
												draw.Text( struc )
											end
											
				GUI_Inv_Item_Remove.DoClick = function()
												LP_RemoveItemFromOffer(data.Item)
											end
		
			end
			
			
			parent:AddItem(GUI_Inv_Item_Panel)
		end
	end	
	
	Inv_Icon_ent:Remove()

end

function GUI_Rebuild_TradeInventory(parent)
	if GUI_TradeInv_Panel_List != nil && GUI_TradeInv_Panel_List:IsValid() then
		GUI_TradeInv_Panel_List:Clear()
	else
		GUI_TradeInv_Panel_List = vgui.Create("DPanelList")
		GUI_TradeInv_Panel_List:SetParent(parent)
		GUI_TradeInv_Panel_List:SetSize(746,240)
		GUI_TradeInv_Panel_List:SetPos(0,0)
		GUI_TradeInv_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_TradeInv_Panel_List:GetWide(),GUI_TradeInv_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_TradeInv_Panel_List:SetPadding(7.5)
		GUI_TradeInv_Panel_List:SetSpacing(5)
		GUI_TradeInv_Panel_List:EnableHorizontal(3)
		GUI_TradeInv_Panel_List:EnableVerticalScrollbar(true)
	end

	local WidthSize = 100
	
	local Inv_Icon_ent = ents.Create("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	

	for item,amount in pairs(Temp_Inventory or {} ) do
	
		if item != "WeightData"  && amount > 0  then
		
			local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
			GUI_Inv_Item_Panel:SetParent(GUI_TradeInv_Panel_List)
			GUI_Inv_Item_Panel:SetSize(120,120)
			GUI_Inv_Item_Panel:SetPos(0,0)
			GUI_Inv_Item_Panel:SetSpacing(5)
			GUI_Inv_Item_Panel.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
			local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
			GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Icon:SetPos(10,10)
			GUI_Inv_Item_Icon:SetSize(WidthSize,WidthSize)
			
			GUI_Inv_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			if GAMEMODE.OCRP_Items[item].Angle != nil then
				GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
			end

			if GAMEMODE.OCRP_Items[item].Material != nil then
				GUI_Inv_Item_Icon:GetEntity():SetMaterial(GAMEMODE.OCRP_Items[item].Material)
			end
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			GUI_Inv_Item_Icon:SetLookAt(center)
			GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
			local GUI_Inv_Item_Name = vgui.Create("DLabel")
			GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Name:SetFont("UIBold")
			GUI_Inv_Item_Name:SetText(GAMEMODE.OCRP_Items[item].Name)
			GUI_Inv_Item_Name:SizeToContents()
			GUI_Inv_Item_Name:SetParent(GUI_Inv_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Name)
			
			GUI_Inv_Item_Name:SetPos(60 - x/2,10-y/2)
			
		--[[	local GUI_Inv_Item_Desc = vgui.Create("DLabel")
			GUI_Inv_Item_Desc:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Desc:SetFont("UIBold")
			GUI_Inv_Item_Desc:SetText(GAMEMODE.OCRP_Items[item].Desc)
			GUI_Inv_Item_Desc:SetWrap(true)
			GUI_Inv_Item_Desc:SetSize(90,40)
			GUI_Inv_Item_Desc:SetParent(GUI_Inv_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Desc)
			
			GUI_Inv_Item_Desc:SetPos(10,110)]]
			
			if amount > 1 then
				local GUI_Inv_Item_Amt = vgui.Create("DLabel")
				GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
				GUI_Inv_Item_Amt:SetFont("UIBold")
				GUI_Inv_Item_Amt:SetText("x"..amount)
				GUI_Inv_Item_Amt:SizeToContents()
				GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("x"..amount)
				
				GUI_Inv_Item_Amt:SetPos(60 - x/2,25-y/2)
			end
			
				local GUI_Inv_Item_Add = vgui.Create("DButton")
				GUI_Inv_Item_Add:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Add:SetPos(10,100)
				GUI_Inv_Item_Add:SetSize(100,15)
				GUI_Inv_Item_Add:SetText("")
				GUI_Inv_Item_Add.Paint = function()
												draw.RoundedBox(4,0,0,GUI_Inv_Item_Add:GetWide(),GUI_Inv_Item_Add:GetTall(),Color( 60, 60, 60, 155 ))
												draw.RoundedBox(4,1,1,GUI_Inv_Item_Add:GetWide()-1,GUI_Inv_Item_Add:GetTall()-1,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
												local struc = {}
												struc.pos = {}
												struc.pos[1] = 50 -- x pos
												struc.pos[2] = 7 -- y pos
												struc.color = Color(255,255,255,255) -- Red
												struc.font = "UIBold" -- Font
												struc.text = "Add" -- Text
												struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
												struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
												draw.Text( struc )
											end
				GUI_Inv_Item_Add.DoClick = function()
												if GAMEMODE.OCRP_Items[item].AmmoType == nil then
													LP_AddItemToOffer(item) 
												else
													GUI_Amount_Popup_Trade(item)
												end
											end
			
			GUI_TradeInv_Panel_List:AddItem(GUI_Inv_Item_Panel)
			
		end
	end
	
	Inv_Icon_ent:Remove()
	
	return GUI_TradeInv_Panel_List

end

function LP_AddItemToOffer(item,amount)

	if amount == nil then
		amount = 1
	end
	
	if amount < 0 then
		amount = 1
	end
	
	if OCRP_Inventory then
		if amount > OCRP_Inventory[item] then
			amount = OCRP_Inventory[item]
		end
	end

	if amount == 0 then
		amount = 1
	end
	
	if amount == nil then
		amount = 1
	end
	
	Temp_Inventory[item] = Temp_Inventory[item] - amount

	for _,data in pairs(LPOffer.Items) do 
		if data.Item == item then
			data.Amount = data.Amount + amount
			GUI_Rebuild_TradeInventory(GUI_Trade_Frame)
			GUI_Rebuild_LocalPlayer_TradeMenu(GUI_Trade_Frame)
			CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,data.Item,data.Amount,_)
			return
		end
	end
	table.insert(LPOffer.Items, {Item = item,Amount = amount})
	for _,data in pairs(LPOffer.Items) do 
		if data.Item == item then
			CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,data.Item,data.Amount,_)
		end
	end
	GUI_Rebuild_TradeInventory(GUI_Trade_Frame)
	GUI_Rebuild_LocalPlayer_TradeMenu(GUI_Trade_Frame)
end

function LP_RemoveItemFromOffer(item,amount)

	if amount == nil then
		amount = 1
	end

	if amount < 0 then
		amount = 1
	end
	
	Temp_Inventory[item] = Temp_Inventory[item] + amount

	for _,data in pairs(LPOffer.Items) do 
		if data.Item == item then
			data.Amount = data.Amount - amount
			if data.Amount <= 0 then
				LPOffer.Items[_] = {Item = "empty",Amount = 0}
			end
			GUI_Rebuild_TradeInventory(GUI_Trade_Frame)
			GUI_Rebuild_LocalPlayer_TradeMenu(GUI_Trade_Frame)
			CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,data.Item,data.Amount,_)
			return
		end
	end

	table.insert(LPOffer.Items, {Item = item,Amount = amount})
		for _,data in pairs(LPOffer.Items) do 
			if data.Item == item then
				CL_SendTradeItem(Temp_TradePlayer,LPOffer.Money,data.Item,data.Amount,_)
			end
		end
	GUI_Rebuild_TradeInventory(GUI_Trade_Frame)
	GUI_Rebuild_LocalPlayer_TradeMenu(GUI_Trade_Frame)
end

function GUI_Amount_Popup_Trade(item)
	if GUI_Amount_Frame != nil && GUI_Amount_Frame:IsValid() then GUI_Amount_Frame:Remove() end
	local GUI_Amount_Frame = vgui.Create("DFrame")
	GUI_Amount_Frame:Center()
	GUI_Amount_Frame:SetSize(200,100)
	GUI_Amount_Frame:MakePopup()
	GUI_Amount_Frame:SetTitle("")
	GUI_Amount_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Amount_Frame:GetWide()-2,GUI_Amount_Frame:GetTall()-2,OCRP_Options.Color)
							end
	local GUI_Amount_slider = vgui.Create("DNumSlider")
	GUI_Amount_slider:SetParent(GUI_Amount_Frame)
	GUI_Amount_slider:SetWide(180)
	GUI_Amount_slider:SetPos(10,25)
	GUI_Amount_slider:SetText("Amount")
	GUI_Amount_slider:SetMin(1)
	GUI_Amount_slider:SetValue(1)
	GUI_Amount_slider:SetMax(OCRP_Inventory[item])
	GUI_Amount_slider:SetDecimals(0)
	
	local GUI_Drop_Button = vgui.Create("DButton")
	GUI_Drop_Button:SetParent(GUI_Amount_Frame)
	GUI_Drop_Button:SetPos(10,70)
	GUI_Drop_Button:SetSize(180,15)
	GUI_Drop_Button:SetText("")
	GUI_Drop_Button.Paint = function()
							draw.RoundedBox(4,0,0,GUI_Drop_Button:GetWide(),GUI_Drop_Button:GetTall(),Color( 60, 60, 60, 155 ))
							draw.RoundedBox(4,1,1,GUI_Drop_Button:GetWide()-2,GUI_Drop_Button:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
							local struc = {}
							struc.pos = {}
							struc.pos[1] = 90 -- x pos
							struc.pos[2] = 7 -- y pos
							struc.color = Color(255,255,255,255) -- Red
							struc.text = "Confirm" -- Text
							struc.font = "UIBold" -- Font
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )
							end
										
	GUI_Drop_Button.DoClick = function()
								LP_AddItemToOffer(item,GUI_Amount_slider:GetValue())
								GUI_Amount_Frame:Remove()
							end
end

local Offer = {Money = 0,Items = {}}

local shopid = 1 

function GUI_ShopMenu(shopi)

	if LocalPlayer():GetNWBool("Handcuffed") then return end
	if GUI_Shop_Frame != nil then
		GUI_Shop_Frame:Remove()
	end
	shopid = tonumber(shopi)
	
	if GAMEMODE.OCRP_Shops[shopid].Restricted != nil then
		for _,team in pairs(GAMEMODE.OCRP_Shops[shopid].Restricted) do
			if LocalPlayer():Team() == team then 
				return 
			end
		end
	end
	
	GUI_Shop_Frame = vgui.Create("DFrame")
	GUI_Shop_Frame:SetTitle("")
	GUI_Shop_Frame:SetSize(768 ,340)
	GUI_Shop_Frame:Center()
	GUI_Shop_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Shop_Frame:GetWide(),GUI_Shop_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Shop_Frame:GetWide()-2,GUI_Shop_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("Trebuchet24")
								local x,y = surface.GetTextSize(GAMEMODE.OCRP_Shops[shopid].Name)
								surface.SetTextPos(10,11 - y/2)
								surface.DrawText(GAMEMODE.OCRP_Shops[shopid].Name)
							end
	GUI_Shop_Frame:MakePopup()
	GUI_Shop_Frame:ShowCloseButton(false)
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Shop_Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(738,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()			
								GUI_Shop_Frame:Remove()
							end
	local GUI_Shop_Desc = vgui.Create("DLabel")
	GUI_Shop_Desc:SetParent(GUI_Shop_Frame)
	GUI_Shop_Desc:SetText(GAMEMODE.OCRP_Shops[shopid].Description)
	GUI_Shop_Desc:SetTextColor(Color(255,255,255,255))
	GUI_Shop_Desc:SetFont("UIBold")
	GUI_Shop_Desc:SetPos(30,23)
	GUI_Shop_Desc:SizeToContents()
	
	local GUI_ShopInv_Panel_List = vgui.Create("DPanelList")
	GUI_ShopInv_Panel_List:SetParent(GUI_Shop_Frame)
	GUI_ShopInv_Panel_List:SetSize(366,280)
	GUI_ShopInv_Panel_List:SetPos(388,40)
	GUI_ShopInv_Panel_List.Paint = function()
								 draw.RoundedBox(8,0,0,GUI_ShopInv_Panel_List:GetWide(),GUI_ShopInv_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
								end
	GUI_ShopInv_Panel_List:SetPadding(7.5)
	GUI_ShopInv_Panel_List:SetSpacing(5)
	GUI_ShopInv_Panel_List:EnableHorizontal(3)
	GUI_ShopInv_Panel_List:EnableVerticalScrollbar(true)
	
	GUI_Rebuild_ShopInventory(GUI_Shop_Frame)
	GUI_Rebuild_Shop_Items(GUI_ShopInv_Panel_List,GAMEMODE.OCRP_Shops[shopid].Items)
end

function GUI_Rebuild_ShopInventory(parent)
	if GUI_ShopInv_Panel_List != nil && GUI_ShopInv_Panel_List:IsValid() then
		GUI_ShopInv_Panel_List:Clear()
	else
		GUI_ShopInv_Panel_List = vgui.Create("DPanelList")
		GUI_ShopInv_Panel_List:SetParent(parent)
		GUI_ShopInv_Panel_List:SetSize(366,280)
		GUI_ShopInv_Panel_List:SetPos(11,40)
		GUI_ShopInv_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_ShopInv_Panel_List:GetWide(),GUI_ShopInv_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_ShopInv_Panel_List:SetPadding(7.5)
		GUI_ShopInv_Panel_List:SetSpacing(5)
		GUI_ShopInv_Panel_List:EnableHorizontal(6)
		GUI_ShopInv_Panel_List:EnableVerticalScrollbar(true)
	end

	GUI_Rebuild_Shop_Player_Items(GUI_ShopInv_Panel_List,OCRP_Inventory or {})
	
	return GUI_ShopInv_Panel_List

end

function GUI_Rebuild_Shop_Player_Items(parent,itemstbl)

	local Inv_Icon_ent = ents.Create("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	for item,amount in pairs(itemstbl) do
		if item != "empty" && amount != 0 && item != "WeightData" then
			local tbl = nil
			if GAMEMODE.OCRP_Shops[shopid].Buying != nil then
				if GAMEMODE.OCRP_Shops[shopid].Buying != false then
					tbl = GAMEMODE.OCRP_Shops[shopid].Buying
				end
			else
				tbl = GAMEMODE.OCRP_Shops[shopid].Items
			end			
			if tbl != nil then
				for _,shopitem in pairs(tbl) do
					if item == shopitem then
						local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
						GUI_Inv_Item_Panel:SetParent(parent)
						
						GUI_Inv_Item_Panel:SetSize(100,120)
						
						GUI_Inv_Item_Panel:SetPos(0,0)
						GUI_Inv_Item_Panel:SetSpacing(5)
						GUI_Inv_Item_Panel.Paint = function()
														draw.RoundedBox(8,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
													end
					
						local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
						GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
						GUI_Inv_Item_Icon:SetPos(0,0)
						GUI_Inv_Item_Icon:SetSize(100,100)
						
						GUI_Inv_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
						
						Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
						
						if GAMEMODE.OCRP_Items[item].Angle != nil then
							GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
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
						
						GUI_Inv_Item_Name:SetPos(50 - x/2,10-y/2)	
					
						if amount > 1 then
							local GUI_Inv_Item_Amt = vgui.Create("DLabel")
							GUI_Inv_Item_Amt:SetColor(Color(255,255,255,255))
							GUI_Inv_Item_Amt:SetFont("UIBold")
							GUI_Inv_Item_Amt:SetText("x"..amount)
							GUI_Inv_Item_Amt:SizeToContents()
							GUI_Inv_Item_Amt:SetParent(GUI_Inv_Item_Panel)
							
							surface.SetFont("UIBold")
							local x,y = surface.GetTextSize("x"..amount)
							
							GUI_Inv_Item_Amt:SetPos(50 - x/2,90-y/2)
						end			
						
						
							local GUI_Inv_Item_Price = vgui.Create("DLabel")
							GUI_Inv_Item_Price:SetColor(Color(200,100,100,255))
							GUI_Inv_Item_Price:SetFont("UIBold")
							GUI_Inv_Item_Price:SetText("$"..math.Round(GAMEMODE.OCRP_Items[item].Price*GAMEMODE.OCRP_Shops[shopid].PriceScale.Buying))
							GUI_Inv_Item_Price:SizeToContents()
							GUI_Inv_Item_Price:SetParent(GUI_Inv_Item_Panel)
						
							surface.SetFont("UIBold")
							local x,y = surface.GetTextSize("$"..math.Round(GAMEMODE.OCRP_Items[item].Price*GAMEMODE.OCRP_Shops[shopid].PriceScale.Buying))
							
							GUI_Inv_Item_Price:SetPos(50 - x/2,60-y/2)

						
							local GUI_Inv_Item_Sell = vgui.Create("DButton")
							GUI_Inv_Item_Sell:SetParent(GUI_Inv_Item_Panel)
							GUI_Inv_Item_Sell:SetPos(5,105)
							GUI_Inv_Item_Sell:SetSize(90,10)
							GUI_Inv_Item_Sell:SetText("")
							GUI_Inv_Item_Sell.Paint = function()
															draw.RoundedBox(4,0,0,GUI_Inv_Item_Sell:GetWide(),GUI_Inv_Item_Sell:GetTall(),Color( 60, 60, 60, 155 ))
															draw.RoundedBox(4,1,1,GUI_Inv_Item_Sell:GetWide()-1,GUI_Inv_Item_Sell:GetTall()-1,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
															
															local struc = {}
															struc.pos = {}
															struc.pos[1] = 45 -- x pos
															struc.pos[2] = 5 -- y pos
															struc.color = Color(255,255,255,255) -- Red
															struc.text = "Sell" -- Text
															struc.font = "UIBold" -- Font
															struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
															struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
															draw.Text( struc )
														end
														
							GUI_Inv_Item_Sell.DoClick = function()
															--LocalPlayer():EmitSound("ocrp/cash_reg.wav",100,100)
															GUI_Amount_Popup_Shop_Sell(item)
															
														end


						
						parent:AddItem(GUI_Inv_Item_Panel)
					end
				end
			end
		end
	end	
	
	Inv_Icon_ent:Remove()

end


function GUI_Rebuild_Shop_Items(parent,shoptbl)

	local shopprice
	local Inv_Icon_ent = ents.Create("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	if  shoptbl != nil then
		for _,item in pairs(shoptbl) do
			if item != nil then
				local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
				GUI_Inv_Item_Panel:SetParent(parent)
				
				GUI_Inv_Item_Panel:SetSize(100,120)
				
				GUI_Inv_Item_Panel:SetPos(0,0)
				GUI_Inv_Item_Panel:SetSpacing(5)
				GUI_Inv_Item_Panel.Paint = function()
												draw.RoundedBox(8,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
											end
			
				local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
				GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Icon:SetPos(0,0)
				GUI_Inv_Item_Icon:SetSize(100,100)

				GUI_Inv_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
				
				Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
				
				if GAMEMODE.OCRP_Items[item].Angle != nil then
					GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
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
				
				GUI_Inv_Item_Name:SetPos(50 - x/2,10-y/2)	

					local GUI_Inv_Item_Price = vgui.Create("DLabel")
					GUI_Inv_Item_Price:SetColor(Color(100,200,100,255))
					GUI_Inv_Item_Price:SetFont("UIBold")
					GUI_Inv_Item_Price:SetText("$".. math.Round(GAMEMODE.OCRP_Items[item].Price*GAMEMODE.OCRP_Shops[shopid].PriceScale.Selling))
					GUI_Inv_Item_Price:SizeToContents()
					GUI_Inv_Item_Price:SetParent(GUI_Inv_Item_Panel)
				
					surface.SetFont("UIBold")
					local x,y = surface.GetTextSize("$".. math.Round(GAMEMODE.OCRP_Items[item].Price*GAMEMODE.OCRP_Shops[shopid].PriceScale.Selling))
					
					GUI_Inv_Item_Price:SetPos(50 - x/2,60-y/2)
				
					local GUI_Inv_Item_Buy = vgui.Create("DButton")
					GUI_Inv_Item_Buy:SetParent(GUI_Inv_Item_Panel)
					GUI_Inv_Item_Buy:SetPos(5,105)
					GUI_Inv_Item_Buy:SetSize(90,10)
					GUI_Inv_Item_Buy:SetText("")
					GUI_Inv_Item_Buy.Paint = function()
													draw.RoundedBox(4,0,0,GUI_Inv_Item_Buy:GetWide(),GUI_Inv_Item_Buy:GetTall(),Color( 60, 60, 60, 155 ))
													draw.RoundedBox(4,1,1,GUI_Inv_Item_Buy:GetWide()-1,GUI_Inv_Item_Buy:GetTall()-1,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
													
													local struc = {}
													struc.pos = {}
													struc.pos[1] = 45 -- x pos
													struc.pos[2] = 5 -- y pos
													struc.color = Color(255,255,255,255) -- Red
													struc.text = "Buy" -- Text
													struc.font = "UIBold" -- Font
													struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
													struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
													draw.Text( struc )
												end
												
					GUI_Inv_Item_Buy.DoClick = function()
													--LocalPlayer():EmitSound("ocrp/cash_reg.wav",100,100)
													GUI_Amount_Popup_Shop(item) 
												end
												
				
				
				parent:AddItem(GUI_Inv_Item_Panel)
			end
		end	
	end
	
	Inv_Icon_ent:Remove()

end

function GUI_Amount_Popup_Shop(item)
	if GUI_Amount_Frame != nil && GUI_Amount_Frame:IsValid() then GUI_Amount_Frame:Remove() end
	local GUI_Amount_Frame = vgui.Create("DFrame")
	GUI_Amount_Frame:SetSize(200,100)
	GUI_Amount_Frame:Center()
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
	GUI_Amount_slider:SetMax(math.Round(LocalPlayer().Wallet/GAMEMODE.OCRP_Items[item].Price))
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
								RunConsoleCommand("afawgfasegas4535tgsw33",item,shopid,math.abs(tonumber(GUI_Amount_slider:GetValue())))
								GUI_Amount_Frame:Remove()
							end
end

function GUI_Amount_Popup_Shop_Sell(item)
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
								RunConsoleCommand("234rqw3tw4yw4yhew45yhws4gye",item,shopid,math.abs(GUI_Amount_slider:GetValue()))
								GUI_Amount_Frame:Remove()
							end
end


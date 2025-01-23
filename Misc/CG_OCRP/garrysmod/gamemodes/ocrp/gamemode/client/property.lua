function CL_UpdateOwnerShip( umsg )
	local OwnerId = umsg:ReadLong()
	local Name = umsg:ReadString()
	for _,data in pairs(GAMEMODE.Properties[string.lower(game.GetMap())]) do
		if data.Name == Name then
			GAMEMODE.Properties[string.lower(game.GetMap())][_].OwnerId = OwnerId
		end
	end
end
usermessage.Hook('OCRP_UpdateOwnerShip', CL_UpdateOwnerShip);

OCRP_ShopItems = {}

function CL_OpenRelatorMenu( umsg )
	GUI_RelatorMenu()
end
usermessage.Hook('OCRP_OpenRelatorMenu', CL_OpenRelatorMenu);

function GUI_RelatorMenu()
	if LocalPlayer():GetNWBool("Handcuffed") then return end
	GUI_Real_Frame = vgui.Create("DFrame")
	GUI_Real_Frame:SetTitle("")
	GUI_Real_Frame:SetSize(525 ,525)
	GUI_Real_Frame:Center()
	GUI_Real_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Real_Frame:GetWide(),GUI_Real_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Real_Frame:GetWide()-2,GUI_Real_Frame:GetTall()-2,OCRP_Options.Color)
								
								--[[surface.SetTextColor(255,255,255,255)
								surface.SetFont("UIBold")
								local x,y = surface.GetTextSize("Inventory")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Inventory")]]--
							end
	GUI_Real_Frame:MakePopup()
	GUI_Real_Frame:ShowCloseButton(false)
	
	local GUI_Property_Sheet = vgui.Create("DPropertySheet")
	GUI_Property_Sheet:SetParent(GUI_Real_Frame)
	GUI_Property_Sheet:SetPos(12.5,10)
	GUI_Property_Sheet:SetSize(500,515 )
	GUI_Property_Sheet.Paint = function() 

								end
								
	local GUI_Real_Exit = vgui.Create("DButton")
	GUI_Real_Exit:SetParent(GUI_Property_Sheet)	
	GUI_Real_Exit:SetSize(20,20)
	GUI_Real_Exit:SetPos(480,0)
	GUI_Real_Exit:SetText("")
	GUI_Real_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Real_Exit:GetWide(),GUI_Real_Exit:GetTall())
									end
	GUI_Real_Exit.DoClick = function()
								GUI_Real_Frame:Remove()
							end

	local GUI_Apart_Panel = vgui.Create("DPanelList")
	GUI_Apart_Panel:SetParent(GUI_Property_Sheet)
	GUI_Apart_Panel:SetSize(500,480)
	GUI_Apart_Panel:SetPos(11,0)
	GUI_Apart_Panel:SetSpacing(5)
	GUI_Apart_Panel:EnableVerticalScrollbar(true)
	GUI_Apart_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Apart_Panel:GetWide(),GUI_Apart_Panel:GetTall(),Color( 60, 60, 60, 155 ))
								end
	
	local GUI_buis_Panel = vgui.Create("DPanelList")
	GUI_buis_Panel:SetParent(GUI_Property_Sheet)
	GUI_buis_Panel:SetSize(500,480)
	GUI_buis_Panel:SetPos(11,0)
	GUI_buis_Panel:SetSpacing(5)
	GUI_buis_Panel:EnableVerticalScrollbar(true)
	GUI_buis_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_buis_Panel:GetWide(),GUI_buis_Panel:GetTall(),Color( 60, 60, 60, 155 ))
								end
								
	local GUI_House_Panel = vgui.Create("DPanelList")
	GUI_House_Panel:SetParent(GUI_Property_Sheet)
	GUI_House_Panel:SetSize(500,480)
	GUI_House_Panel:SetPos(11,0)
	GUI_House_Panel:SetSpacing(5)
	GUI_House_Panel:EnableVerticalScrollbar(true)
	GUI_House_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_House_Panel:GetWide(),GUI_House_Panel:GetTall(),Color( 60, 60, 60, 155 ))
								end
	
	GUI_Property_Sheet:AddSheet( "Apartments", GUI_Apart_Panel, "gui/silkicons/star", true, false )
	GUI_Property_Sheet:AddSheet( "Buisnesses", GUI_buis_Panel, "gui/silkicons/group", true, false)
	GUI_Property_Sheet:AddSheet( "Houses", GUI_House_Panel, "gui/silkicons/user", true, false)
	
local parent = GUI_Apart_Panel

	for key,data in pairs(GAMEMODE.Properties[string.lower(game.GetMap())]) do
		if data.Type == "Apartment" then
			parent = GUI_Apart_Panel
		elseif data.Type == "Buisness" then
			parent = GUI_buis_Panel
		elseif data.Type == "House" then
			parent = GUI_House_Panel
		end
			local GUI_Property_Panel = vgui.Create("DPanelList")
			GUI_Property_Panel:SetParent(parent)
			GUI_Property_Panel:SetSize(500,100)
			GUI_Property_Panel:SetPos(0,0)
			GUI_Property_Panel:SetSpacing(5)
			GUI_Property_Panel.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Property_Panel:GetWide(),GUI_Property_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
			local GUI_Inv_Item_Name = vgui.Create("DLabel")
			GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Name:SetFont("Trebuchet22")
			GUI_Inv_Item_Name:SetText(data.Name)
			GUI_Inv_Item_Name:SizeToContents()
			GUI_Inv_Item_Name:SetParent(GUI_Property_Panel)
			
			surface.SetFont("Trebuchet22")
			local x,y = surface.GetTextSize(data.Name)
			
			GUI_Inv_Item_Name:SetPos(250 - x/2,15-y/2)
			
			local GUI_Property_Desc = vgui.Create("DLabel")
			GUI_Property_Desc:SetColor(Color(255,255,255,255))
			GUI_Property_Desc:SetFont("Trebuchet18")
			GUI_Property_Desc:SetText(data.Desc)
			GUI_Property_Desc:SetWrap(true)
			GUI_Property_Desc:SetSize(250,50)
			GUI_Property_Desc:SetParent(GUI_Property_Panel)
			GUI_Property_Desc:SetPos(100,25)
			
			if #data.PropVectors > 1 then
				local GUI_Door_Amt = vgui.Create("DLabel")
				GUI_Door_Amt:SetColor(Color(255,100,100,255))
				GUI_Door_Amt:SetFont("UIBold")
				GUI_Door_Amt:SetText(#data.PropVectors.." Doors")
				GUI_Door_Amt:SizeToContents()
				GUI_Door_Amt:SetParent(GUI_Property_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize(#data.PropVectors.." Doors")
				
				GUI_Door_Amt:SetPos(250 - x/2,75-y/2)
			else
				local GUI_Door_Amt = vgui.Create("DLabel")
				GUI_Door_Amt:SetColor(Color(255,100,100,255))
				GUI_Door_Amt:SetFont("UIBold")
				GUI_Door_Amt:SetText(#data.PropVectors.." Door")
				GUI_Door_Amt:SizeToContents()
				GUI_Door_Amt:SetParent(GUI_Property_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize(#data.PropVectors.." Door")
				
				GUI_Door_Amt:SetPos(250 - x/2,75-y/2)
			end
											
										--end
						if !player.GetByID(data.OwnerId):IsValid() then
							data.OwnerId = 0
						end
						if data.OwnerId == LocalPlayer():EntIndex() then
							local GUI_Property_Sell = vgui.Create("DButton")
							GUI_Property_Sell:SetParent(GUI_Property_Panel)
							GUI_Property_Sell:SetPos(390,50)
							GUI_Property_Sell:SetSize(80,20)
							GUI_Property_Sell:SetText("")
							GUI_Property_Sell.Paint = function()
															draw.RoundedBox(8,0,0,GUI_Property_Sell:GetWide(),GUI_Property_Sell:GetTall(),Color( 60, 60, 60, 155 ))
															draw.RoundedBox(8,1,1,GUI_Property_Sell:GetWide()-2,GUI_Property_Sell:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
															
															local struc = {}
															struc.pos = {}
															struc.pos[1] = 40 -- x pos
															struc.pos[2] = 10 -- y pos
															struc.color = Color(255,255,255,255) -- Red
															struc.text = "Sell for $"..data.Price/2 -- Text
															struc.font = "UIBold" -- Font
															struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
															struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
															draw.Text( struc )
														end
														
							GUI_Property_Sell.DoClick = function()
															RunConsoleCommand("OCRP_Sell_Property",key) 
															GUI_Real_Frame:Remove()
														end					
					elseif data.OwnerId == 0 || data.OwnerId == nil then
							local GUI_Property_Buy = vgui.Create("DButton")
							GUI_Property_Buy:SetParent(GUI_Property_Panel)
							GUI_Property_Buy:SetPos(390,50)
							GUI_Property_Buy:SetSize(80,20)
							GUI_Property_Buy:SetText("")
							GUI_Property_Buy.Paint = function()
															draw.RoundedBox(8,0,0,GUI_Property_Buy:GetWide(),GUI_Property_Buy:GetTall(),Color( 60, 60, 60, 155 ))
															draw.RoundedBox(8,1,1,GUI_Property_Buy:GetWide()-2,GUI_Property_Buy:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
															
															local struc = {}
															struc.pos = {}
															struc.pos[1] = 40 -- x pos
															struc.pos[2] = 10 -- y pos
															struc.color = Color(255,255,255,255) -- Red
															struc.text = "Buy for $"..data.Price -- Text
															struc.font = "UIBold" -- Font
															struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
															struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
															draw.Text( struc )
														end
														
							GUI_Property_Buy.DoClick = function()
															RunConsoleCommand("OCRP_Buy_Property",key) 
															GUI_Real_Frame:Remove()
														end
					else
						local GUI_Property_Owned = vgui.Create("DLabel")
						GUI_Property_Owned:SetColor(Color(255,100,100,255))
						GUI_Property_Owned:SetFont("UIBold")
						GUI_Property_Owned:SetText("Sold")
						GUI_Property_Owned:SizeToContents()
						GUI_Property_Owned:SetParent(GUI_Property_Panel)
							
						surface.SetFont("UIBold")
						local x,y = surface.GetTextSize("Sold")
							
						GUI_Property_Owned:SetPos(50 - x/2,50-y/2)
					end
			parent:AddItem(GUI_Property_Panel)
	end
	
	for _,panel in pairs(GUI_Property_Sheet.Items) do
		panel.Tab:SetAutoStretchVertical(false)
		panel.Tab:SetSize(50,50)
		panel.Tab.Paint = function() 
							draw.RoundedBox(8,0,0,panel.Tab:GetWide()-4,panel.Tab:GetTall()+15,Color( 60, 60, 60, 155 ))
						end
	end							
							
end
--concommand.Add("OCRP_RelatorMenu", function(ply,cmd,args) GUI_RelatorMenu() end)

function GUI_ChangePermissions(door)
	if GUI_Door_Frame != nil && GUI_Door_Frame:IsValid() then return end
	GUI_Door_Frame = vgui.Create("DFrame")
	GUI_Door_Frame:SetTitle("")
	GUI_Door_Frame:SetSize(250 ,200)
	GUI_Door_Frame:Center()
	GUI_Door_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Door_Frame:GetWide(),GUI_Door_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Door_Frame:GetWide()-2,GUI_Door_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UIBold")
								local x,y = surface.GetTextSize("Permissions")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Permissions")
							end
	GUI_Door_Frame:MakePopup()
	GUI_Door_Frame:ShowCloseButton(false)
				
	local GUI_Door_Exit = vgui.Create("DButton")
	GUI_Door_Exit:SetParent(GUI_Door_Frame)	
	GUI_Door_Exit:SetSize(20,20)
	GUI_Door_Exit:SetPos(225,5)
	GUI_Door_Exit:SetText("")
	GUI_Door_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Door_Exit:GetWide(),GUI_Door_Exit:GetTall())
									end
	GUI_Door_Exit.DoClick = function()
								GUI_Door_Frame:Remove()
							end
							
	local GUI_Door_Panel = vgui.Create("DPropertySheet")
	GUI_Door_Panel:SetParent(GUI_Door_Frame)
	GUI_Door_Panel:SetPos(10,25)
	GUI_Door_Panel:SetSize(230,165 )
	GUI_Door_Panel.Paint = function() 
									draw.RoundedBox(8,0,0,GUI_Door_Panel:GetWide(),GUI_Door_Panel:GetTall(),Color( 60, 60, 60, 155 ))
								end						
	
	local GUI_Door_Label = vgui.Create( "DLabel" )
	GUI_Door_Label:SetParent(GUI_Door_Panel)
	GUI_Door_Label:SetFont("UIBold")
	GUI_Door_Label:SetText( "Who can lock/unlock this door?" )
	GUI_Door_Label:SizeToContents()
	GUI_Door_Label:SetPos(10,10)

	local GUI_Door_Org_Box = vgui.Create( "DCheckBoxLabel" )
	GUI_Door_Org_Box:SetParent(GUI_Door_Panel)
	GUI_Door_Org_Box:SetText( "Allow Orginisation Members" )
	GUI_Door_Org_Box:SizeToContents()
	GUI_Door_Org_Box:SetPos(10,40)	

	local GUI_Door_Bud_Box = vgui.Create( "DCheckBoxLabel" )
	GUI_Door_Bud_Box:SetParent(GUI_Door_Panel)
	GUI_Door_Bud_Box:SetText( "Allow Buddies" )
	GUI_Door_Bud_Box:SizeToContents()
	GUI_Door_Bud_Box:SetPos(10,60)		

	local GUI_Door_Gov_Box = vgui.Create( "DCheckBoxLabel" )
	GUI_Door_Gov_Box:SetParent(GUI_Door_Panel)
	GUI_Door_Gov_Box:SetText( "Allow Goverement Officials" )
	GUI_Door_Gov_Box:SizeToContents()
	GUI_Door_Gov_Box:SetPos(10,80)	

	local GUI_Door_Mayor_Box = vgui.Create( "DCheckBoxLabel" )
	GUI_Door_Mayor_Box:SetParent(GUI_Door_Panel)
	GUI_Door_Mayor_Box:SetText( "Allow the mayor" )
	GUI_Door_Mayor_Box:SizeToContents()
	GUI_Door_Mayor_Box:SetPos(10,100)		
	
	local GUI_Door_Button = vgui.Create("DButton")
	GUI_Door_Button:SetParent(GUI_Door_Frame)
	GUI_Door_Button:SetPos(20,150)
	GUI_Door_Button:SetSize(210,30)
	GUI_Door_Button:SetTextColor(Color(0,0,0,255))
	GUI_Door_Button:SetText("Confirm Permissions")
	
	if door.Permissions != nil then
		if door.Permissions["Buddies"] then
			GUI_Door_Bud_Box:SetValue(1)
			GUI_Door_Bud_Box:SetChecked(true)
		end
		if door.Permissions["Org"] then
			GUI_Door_Org_Box:SetValue(1)
			GUI_Door_Org_Box:SetChecked(true)
		end
		if door.Permissions["Goverment"] then
			GUI_Door_Gov_Box:SetValue(1)
			GUI_Door_Gov_Box:SetChecked(true)
		end
		if door.Permissions["Mayor"] then
			GUI_Door_Mayor_Box:SetValue(1)
			GUI_Door_Mayor_Box:SetChecked(true)
		end
	end

	GUI_Door_Button.Paint = function()
								draw.RoundedBox(4,0,0,GUI_Door_Button:GetWide(),GUI_Door_Button:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(4,1,1,GUI_Door_Button:GetWide()-2,GUI_Door_Button:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
							
	GUI_Door_Button.DoClick = function()
								door.Permissions = {}
								door.Permissions["Buddies"] = GUI_Door_Bud_Box:GetChecked()
								door.Permissions["Org"] = GUI_Door_Org_Box:GetChecked()
								door.Permissions["Goverment"] = GUI_Door_Gov_Box:GetChecked()
								door.Permissions["Mayor"] = GUI_Door_Mayor_Box:GetChecked()	
								
								RunConsoleCommand("OCRP_Set_Permissions",tostring(door.Permissions["Org"]),tostring(door.Permissions["Buddies"]),tostring(door.Permissions["Goverment"]),tostring(door.Permissions["Mayor"]))
								GUI_Door_Frame:Remove()
								end
	
end

function CL_PriceItem( umsg )
	local pricingnow = umsg:ReadBool()
	local ent = umsg:ReadEntity()
	local price = umsg:ReadLong()
	local desc = umsg:ReadString()
	local amount = umsg:ReadLong()
	if !ent:IsValid() then return end
	if pricingnow then
		GUI_Price_Item(ent)
	else 
		table.insert(OCRP_ShopItems,ent)
		ent.cl_price = price
		ent.cl_desc = desc
		ent.cl_amount = amount 
	end
end
usermessage.Hook('CL_PriceItem', CL_PriceItem);

function GUI_Price_Item(obj)
	if GUI_Price_Frame != nil && GUI_Price_Frame:IsValid() then return end
	GUI_Price_Frame = vgui.Create("DFrame")
	GUI_Price_Frame:SetSize(200,100)
	GUI_Price_Frame:Center()
	GUI_Price_Frame:SetTitle("Set Item Price")
	GUI_Price_Frame:MakePopup(true)
	GUI_Price_Frame.Paint = function() 
									draw.RoundedBox(8,1,1,	GUI_Price_Frame:GetWide()-2,	GUI_Price_Frame:GetTall()-2,OCRP_Options.Color)
								end
	
	GUI_Price_Desc = vgui.Create("DTextEntry")
	GUI_Price_Desc:SetParent(GUI_Price_Frame)
	GUI_Price_Desc:SetSize(180,15)
	GUI_Price_Desc:SetPos(10,25)
	GUI_Price_Desc:SetEditable(true)
	GUI_Price_Desc:SetText("Enter the description")
	GUI_Price_Desc:SetUpdateOnType(true)
	GUI_Price_Desc:SetNumeric(false)
	
	GUI_Price_Price = vgui.Create("DTextEntry")
	GUI_Price_Price:SetParent(GUI_Price_Frame)
	GUI_Price_Price:SetSize(180,15)
	GUI_Price_Price:SetPos(10,50)
	GUI_Price_Price:SetText("Enter the Price")
	GUI_Price_Price:SetEditable(true)
	GUI_Price_Price:SetUpdateOnType(true)
	GUI_Price_Price:SetNumeric(true)

	local GUI_Price_Button = vgui.Create("DButton")
	GUI_Price_Button:SetParent(GUI_Price_Frame)
	GUI_Price_Button:SetPos(10,70)
	GUI_Price_Button:SetSize(180,20)
	GUI_Price_Button:SetTextColor(Color(0,0,0,255))
	GUI_Price_Button:SetText("Confirm")
	

	GUI_Price_Button.Paint = function()
								draw.RoundedBox(4,0,0,GUI_Price_Button:GetWide(),GUI_Price_Button:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(4,1,1,GUI_Price_Button:GetWide()-2,GUI_Price_Button:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
							
	GUI_Price_Button.DoClick = function()
									if tonumber(GUI_Price_Price:GetValue()) > 0 then
										if GUI_Price_Desc:GetValue() == "Enter the description" then
											GUI_Price_Desc:SetValue("")
										end
										RunConsoleCommand("OCRP_PriceItem",obj:EntIndex(),tonumber(GUI_Price_Price:GetValue()),tostring(GUI_Price_Desc:GetValue()))
										GUI_Price_Frame:Remove()
									end
								end
end


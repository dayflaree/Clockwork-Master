local vgui = vgui
local draw = draw
local surface = surface

function CL_UpdateItem( umsg )
	local item = umsg:ReadString()
	local amount = umsg:ReadLong()
	local weightcur = umsg:ReadLong()
	local weightmax = umsg:ReadLong()
	
	OCRP_Inventory.WeightData = {Cur = tonumber(weightcur),Max = tonumber(weightmax)}
	OCRP_Inventory[tostring(item)] = tonumber(amount)
	
	if GUI_Main_Frame != nil && GUI_Main_Frame:IsValid() then
		GUI_Rebuild_Inventory(GUI_Inv_tab_Panel)
	elseif GUI_Shop_Frame != nil && GUI_Shop_Frame:IsValid() then
		GUI_Rebuild_ShopInventory(GUI_Shop_Frame)
	elseif GUI_Object_Inv_Frame != nil && GUI_Object_Inv_Frame:IsValid() then
		local USEABLE = true 
		if OCRP_Object:IsPlayer() then
			USEABLE = false
		end		
		if USEABLE then
			GUI_Reload_Object_LP_Inventory(GUI_Object_Inv_Frame)
		end
	elseif GUI_LootObj_Inv_Frame != nil && GUI_LootObj_Inv_Frame:IsValid() then
		GUI_Reload_LootObj_LP_Inventory(GUI_LootObj_Inv_Frame)
	end
end
usermessage.Hook('OCRP_UpdateItem', CL_UpdateItem);

function GUI_Rebuild_Inventory(parent)
	if GUI_Inv_Panel_List != nil && GUI_Inv_Panel_List:IsValid() then
		GUI_Inv_Panel_List:Clear()
		GUI_Weight_Bevel:Remove()
	else
		GUI_Inv_Panel_List = vgui.Create("DPanelList")
		GUI_Inv_Panel_List:SetParent(parent)
		GUI_Inv_Panel_List:SetSize(746,460)
		GUI_Inv_Panel_List:SetPos(0,0)
		GUI_Inv_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Inv_Panel_List:GetWide(),GUI_Inv_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_Inv_Panel_List:SetPadding(7.5)
		GUI_Inv_Panel_List:SetSpacing(2)
		GUI_Inv_Panel_List:EnableHorizontal(3)
		GUI_Inv_Panel_List:EnableVerticalScrollbar(true)
		
	end

	GUI_Weight_Bevel = vgui.Create("DBevel")
	GUI_Weight_Bevel:SetParent(parent)
	GUI_Weight_Bevel:SetSize(746,18)
	GUI_Weight_Bevel:SetPos(0,461)
	GUI_Weight_Bevel.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Weight_Bevel:GetWide(),GUI_Weight_Bevel:GetTall(),Color( 60, 60, 60, 255 ))
								if (GUI_Weight_Bevel:GetWide()*(OCRP_Inventory.WeightData.Cur/OCRP_Inventory.WeightData.Max)) > 8 then
									draw.RoundedBox(8,1,1,(GUI_Weight_Bevel:GetWide()*(OCRP_Inventory.WeightData.Cur/OCRP_Inventory.WeightData.Max))-1,GUI_Weight_Bevel:GetTall()-1,Color( 200, 200, 200, 255 ))
								end
							end
	GUI_Weight_Bevel.PaintOver = function() 
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 338 -- x pos
										struc.pos[2] = 9 -- y pos
										struc.color = Color( 30, 30, 30, 255 ) -- Red
										struc.font = "UIBold" -- Font
										struc.text = "Weight: "..OCRP_Inventory.WeightData.Cur.."/"..OCRP_Inventory.WeightData.Max -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )			
									end	
	
	local WidthSize = 100
	
	local Inv_Icon_ent = ents.Create("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	for item,amount in pairs(OCRP_Inventory or {} ) do

		if item != "WeightData" && amount > 0  then
		
			local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
			GUI_Inv_Item_Panel:SetParent(GUI_Inv_Panel_List)
			GUI_Inv_Item_Panel:SetSize(120,150)
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
		
			GUI_Inv_Item_Icon.OnCursorEntered = function()
												GUI_Inv_Stats_Panel = vgui.Create("DPanel")
												GUI_Inv_Stats_Panel:SetParent(GUI_Inv_Panel_List)
												GUI_Inv_Stats_Panel.Paint = function() 
																				draw.RoundedBox(8,0,0,GUI_Inv_Stats_Panel:GetWide(),GUI_Inv_Stats_Panel:GetTall(),Color( 60, 60, 60, 255 )) 
																			end
												
												local GUI_Inv_Stat_Desc = vgui.Create("DLabel")
												GUI_Inv_Stat_Desc:SetParent(GUI_Inv_Stats_Panel)
												GUI_Inv_Stat_Desc:SetPos(5,5)
												GUI_Inv_Stat_Desc:SetColor(Color(255,255,255,255))
												GUI_Inv_Stat_Desc:SetText(GAMEMODE.OCRP_Items[item].Desc)
												GUI_Inv_Stat_Desc:SetFont("Trebuchet20")
												GUI_Inv_Stat_Desc:SizeToContents()
												
												local num = 10
												local num1 = GUI_Inv_Stat_Desc:GetWide()
												
												GUI_Inv_Stats_Panel:SetSize(num1 + 20,num + 25)
												local x,y = GUI_Inv_Panel_List:GetPos()
												local xpos,ypos = (x + GUI_Inv_Stats_Panel:GetWide()),(y + GUI_Inv_Stats_Panel:GetTall())
												if xpos + GUI_Inv_Stats_Panel:GetWide() > GUI_Inv_Panel_List:GetWide() then
													xpos = (x - GUI_Inv_Stats_Panel:GetWide())
												end
												if ypos + GUI_Inv_Stats_Panel:GetTall() > GUI_Inv_Panel_List:GetTall() then
													ypos = (y - GUI_Inv_Stats_Panel:GetTall())
												end
												GUI_Inv_Stats_Panel:SetPos(xpos ,ypos)
											end
			GUI_Inv_Item_Icon.OnCursorExited = function()
											if GUI_Inv_Stats_Panel != nil && GUI_Inv_Stats_Panel:IsValid() then
												GUI_Inv_Stats_Panel:Remove()
											end
										end		
		
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
			
			if GAMEMODE.OCRP_Items[item].Function != nil then
				local GUI_Inv_Item_Use = vgui.Create("DButton")
				GUI_Inv_Item_Use:SetParent(GUI_Inv_Item_Panel)
				GUI_Inv_Item_Use:SetPos(10,100)
				GUI_Inv_Item_Use:SetSize(100,15)
				GUI_Inv_Item_Use:SetText("")
				GUI_Inv_Item_Use.Paint = function()
												draw.RoundedBox(4,0,0,GUI_Inv_Item_Use:GetWide(),GUI_Inv_Item_Use:GetTall(),Color( 60, 60, 60, 155 ))
												draw.RoundedBox(4,1,1,GUI_Inv_Item_Use:GetWide()-2,GUI_Inv_Item_Use:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
												local struc = {}
												struc.pos = {}
												struc.pos[1] = 50 -- x pos
												struc.pos[2] = 7 -- y pos
												struc.color = Color(255,255,255,255) -- Red
												struc.font = "UIBold" -- Font
												struc.text = "Use" -- Text
												struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
												struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
												draw.Text( struc )
											end
				GUI_Inv_Item_Use.DoClick = function()
												if GAMEMODE.OCRP_Items[item].Condition(LocalPlayer(),item) then
													RunConsoleCommand("OCRP_Useitem",item) 
												end
											end
			end
				
			local GUI_Inv_Item_Drop = vgui.Create("DButton")
			GUI_Inv_Item_Drop:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Drop:SetPos(10,120)
			GUI_Inv_Item_Drop:SetSize(100,15)
			GUI_Inv_Item_Drop:SetText("")
			GUI_Inv_Item_Drop.Paint = function()
											draw.RoundedBox(4,0,0,GUI_Inv_Item_Drop:GetWide(),GUI_Inv_Item_Drop:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(4,1,1,GUI_Inv_Item_Drop:GetWide()-2,GUI_Inv_Item_Drop:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
											local struc = {}
											struc.pos = {}
											struc.pos[1] = 50 -- x pos
											struc.pos[2] = 7 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Drop" -- Text
											struc.font = "UIBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
										end
										
			GUI_Inv_Item_Drop.DoClick = function()
											if GAMEMODE.OCRP_Items[item].AmmoType == nil then
												RunConsoleCommand("OCRP_Dropitem",item,1) 
											else
												GUI_Amount_Popup(item)
											end
										end
			
			GUI_Inv_Panel_List:AddItem(GUI_Inv_Item_Panel)
			
		end
	end
	
	Inv_Icon_ent:Remove()
	
	return GUI_Inv_Panel_List

end

function GUI_Amount_Popup(item)
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
								RunConsoleCommand("OCRP_Dropitem",item,GUI_Amount_slider:GetValue())
								GUI_Amount_Frame:Remove()
							end
end

function AFKPopup()
	if GUI_Amount_Frame != nil && GUI_Amount_Frame:IsValid() then GUI_Amount_Frame:Remove() end
	local GUI_Amount_Frame = vgui.Create("DFrame")
	GUI_Amount_Frame:Center()
	GUI_Amount_Frame:SetSize(220,70)
	GUI_Amount_Frame:MakePopup()
	GUI_Amount_Frame:SetTitle("AFK: Are you there?")
	GUI_Amount_Frame:ShowCloseButton(false)
	GUI_Amount_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Amount_Frame:GetWide()-2,GUI_Amount_Frame:GetTall()-2,OCRP_Options.Color)
							end
	
	local GUI_AFK_TEXT = vgui.Create( "DLabel" )
	GUI_AFK_TEXT:SetParent(GUI_Amount_Frame)
	GUI_AFK_TEXT:SetText( "The AFK kicker thinks your AFK, are you?" )
	GUI_AFK_TEXT:SetPos(10,25)
	GUI_AFK_TEXT:SetColor(Color(255,255,255,255))
	GUI_AFK_TEXT:SizeToContents()
	
	local GUI_Drop_Button = vgui.Create("DButton")
	GUI_Drop_Button:SetParent(GUI_Amount_Frame)
	GUI_Drop_Button:SetPos(10,45)
	GUI_Drop_Button:SetSize(200,15)
	GUI_Drop_Button:SetText("")
	GUI_Drop_Button.Paint = function()
							draw.RoundedBox(4,0,0,GUI_Drop_Button:GetWide(),GUI_Drop_Button:GetTall(),Color( 60, 60, 60, 155 ))
							draw.RoundedBox(4,1,1,GUI_Drop_Button:GetWide()-2,GUI_Drop_Button:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
							local struc = {}
							struc.pos = {}
							struc.pos[1] = 90 -- x pos
							struc.pos[2] = 7 -- y pos
							struc.color = Color(255,255,255,255) -- Red
							struc.text = "No, I'm not." -- Text
							struc.font = "UIBold" -- Font
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )
							end
										
	GUI_Drop_Button.DoClick = function()
								RunConsoleCommand("OCRP_NotAFK")
								GUI_Amount_Frame:Remove()
							end
end
usermessage.Hook("ShowAFKWindow", AFKPopup)

function GM:OnContextMenuOpen()
	if LocalPlayer():GetActiveWeapon():IsValid() && LocalPlayer():GetActiveWeapon():Clip1() > 0 then
		RunConsoleCommand("OCRP_EmptyCurWeapon")
	end
end

function CL_HasItem(item,amount)
	
	if amount == nil then amount = 1 end
	if OCRP_Inventory[item] == nil then return false end
	if OCRP_Inventory[item] >= amount then
		return true
	end
	return false
end

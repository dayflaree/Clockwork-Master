function GUI_LootObj_Inventory()
	GUI_LootObj_Inv_Frame = vgui.Create("DFrame")
	GUI_LootObj_Inv_Frame:SetTitle("")
	GUI_LootObj_Inv_Frame:SetSize(800 ,530)
	GUI_LootObj_Inv_Frame:Center()
	GUI_LootObj_Inv_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_LootObj_Inv_Frame:GetWide()-2,GUI_LootObj_Inv_Frame:GetTall()-2,OCRP_Options.Color)
							end
	GUI_LootObj_Inv_Frame:MakePopup()
	GUI_LootObj_Inv_Frame:ShowCloseButton(false)
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_LootObj_Inv_Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(780,0)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()
								OCRP_Object_Inventory = {}
								GUI_LootObj_Inv_Frame:Remove()
								if GUI_Loot_1 != nil && GUI_Loot_1:IsValid() then
									LOOTING = false
									GUI_Loot_1:Remove()
								end
								
							end
							
	GUI_Reload_LootObj_Inventory(GUI_LootObj_Inv_Frame)
	GUI_Reload_LootObj_LP_Inventory(GUI_LootObj_Inv_Frame)
	
end

function GUI_Reload_LootObj_Inventory(parent)
	if GUI_LootObj_Inv_Panel_List != nil && GUI_LootObj_Inv_Panel_List:IsValid() then
		GUI_LootObj_Inv_Panel_List:Clear()
		GUI_Weight_LootObj_Bevel:Remove()
	else
		GUI_LootObj_Inv_Panel_List = vgui.Create("DPanelList")
		GUI_LootObj_Inv_Panel_List:SetParent(parent)
		GUI_LootObj_Inv_Panel_List:SetSize(385,480)
		GUI_LootObj_Inv_Panel_List:SetPos(400,20)
		GUI_LootObj_Inv_Panel_List.Paint = function()
										draw.RoundedBox(8,0,0,GUI_LootObj_Inv_Panel_List:GetWide(),GUI_LootObj_Inv_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
										end
		GUI_LootObj_Inv_Panel_List:SetPadding(7.5)
		GUI_LootObj_Inv_Panel_List:SetSpacing(5)
		GUI_LootObj_Inv_Panel_List:EnableHorizontal(3)
		GUI_LootObj_Inv_Panel_List:EnableVerticalScrollbar(true)

	end

	GUI_Weight_LootObj_Bevel = vgui.Create("DBevel")
	GUI_Weight_LootObj_Bevel:SetParent(GUI_LootObj_Inv_Frame)
	GUI_Weight_LootObj_Bevel:SetSize(380,18)
	GUI_Weight_LootObj_Bevel:SetPos(400,505)			
	GUI_Weight_LootObj_Bevel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Weight_LootObj_Bevel:GetWide(),GUI_Weight_LootObj_Bevel:GetTall(),Color( 60, 60, 60, 255 ))
									if (GUI_Weight_LootObj_Bevel:GetWide()*(OCRP_Object_Inventory.WeightData.Cur/OCRP_Object_Inventory.WeightData.Max)) > 8 then
										draw.RoundedBox(8,1,1,(GUI_Weight_LootObj_Bevel:GetWide()*(OCRP_Object_Inventory.WeightData.Cur/OCRP_Object_Inventory.WeightData.Max))-1,GUI_Weight_LootObj_Bevel:GetTall()-1,Color( 200, 200, 200, 255 ))
									end
								end
	GUI_Weight_LootObj_Bevel.PaintOver = function() 
										local struc = {}
										struc.pos = {}
										struc.pos[1] = GUI_Weight_LootObj_Bevel:GetWide()/2 -- x pos
										struc.pos[2] = 9 -- y pos
										struc.color = Color( 30, 30,30, 255 ) -- Red
										struc.font = "UIBold" -- Font
										struc.text = "Weight: "..OCRP_Object_Inventory.WeightData.Cur.."/"..OCRP_Object_Inventory.WeightData.Max -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )			
									end
	
	local WidthSize = 100
	
	local Inv_Icon_ent = ents.Create("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
	
	for item,amount in pairs(OCRP_Object_Inventory or {} ) do
	
		if item != "WeightData" && amount > 0 then
			if GAMEMODE.OCRP_Items[item].LootData != nil then
				if CL_HasSkill("skill_loot",GAMEMODE.OCRP_Items[item].LootData.Level) then 
					local GUI_LootObj_Inv_Item_Panel = vgui.Create("DPanelList")
					GUI_LootObj_Inv_Item_Panel:SetParent(GUI_LootObj_Inv_Panel_List)
					GUI_LootObj_Inv_Item_Panel:SetSize(120,120)
					GUI_LootObj_Inv_Item_Panel:SetPos(0,0)
					GUI_LootObj_Inv_Item_Panel:SetSpacing(5)
					GUI_LootObj_Inv_Item_Panel.Paint = function()
												draw.RoundedBox(8,0,0,GUI_LootObj_Inv_Item_Panel:GetWide(),GUI_LootObj_Inv_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
												end
				
					local GUI_LootObj_Inv_Item_Icon = vgui.Create("DModelPanel")
					GUI_LootObj_Inv_Item_Icon:SetParent(GUI_LootObj_Inv_Item_Panel)
					GUI_LootObj_Inv_Item_Icon:SetPos(10,10)
					GUI_LootObj_Inv_Item_Icon:SetSize(WidthSize,WidthSize)
					
					GUI_LootObj_Inv_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
					
					Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
					
					if GAMEMODE.OCRP_Items[item].Angle != nil then
						GUI_LootObj_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
					end

					if GAMEMODE.OCRP_Items[item].Material != nil then
						GUI_LootObj_Inv_Item_Icon:GetEntity():SetMaterial(GAMEMODE.OCRP_Items[item].Material)
					end
					
					local center = Inv_Icon_ent:OBBCenter()
					local dist = Inv_Icon_ent:BoundingRadius()*1.2
					GUI_LootObj_Inv_Item_Icon:SetLookAt(center)
					GUI_LootObj_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
				
					local GUI_LootObj_Inv_Item_Name = vgui.Create("DLabel")
					GUI_LootObj_Inv_Item_Name:SetColor(Color(255,255,255,255))
					GUI_LootObj_Inv_Item_Name:SetFont("UIBold")
					GUI_LootObj_Inv_Item_Name:SetText(GAMEMODE.OCRP_Items[item].Name)
					GUI_LootObj_Inv_Item_Name:SizeToContents()
					GUI_LootObj_Inv_Item_Name:SetParent(GUI_LootObj_Inv_Item_Panel)
					
					surface.SetFont("UIBold")
					local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Name)
					
					GUI_LootObj_Inv_Item_Name:SetPos(60 - x/2,10-y/2)
					
				--[[	local GUI_LootObj_Inv_Item_Desc = vgui.Create("DLabel")
					GUI_LootObj_Inv_Item_Desc:SetColor(Color(255,255,255,255))
					GUI_LootObj_Inv_Item_Desc:SetFont("UIBold")
					GUI_LootObj_Inv_Item_Desc:SetText(GAMEMODE.OCRP_Items[item].Desc)
					GUI_LootObj_Inv_Item_Desc:SetWrap(true)
					GUI_LootObj_Inv_Item_Desc:SetSize(90,40)
					GUI_LootObj_Inv_Item_Desc:SetParent(GUI_LootObj_Inv_Item_Panel)
					
					surface.SetFont("UIBold")
					local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Desc)
					
					GUI_LootObj_Inv_Item_Desc:SetPos(10,110)]]
					
					if amount > 1 then
						local GUI_LootObj_Inv_Item_Amt = vgui.Create("DLabel")
						GUI_LootObj_Inv_Item_Amt:SetColor(Color(255,255,255,255))
						GUI_LootObj_Inv_Item_Amt:SetFont("UIBold")
						GUI_LootObj_Inv_Item_Amt:SetText("x"..amount)
						GUI_LootObj_Inv_Item_Amt:SizeToContents()
						GUI_LootObj_Inv_Item_Amt:SetParent(GUI_LootObj_Inv_Item_Panel)
						
						surface.SetFont("UIBold")
						local x,y = surface.GetTextSize("x"..amount)
						
						GUI_LootObj_Inv_Item_Amt:SetPos(60 - x/2,25-y/2)
					end
					
					local GUI_LootObj_Item_Withdraw = vgui.Create("DButton")
					GUI_LootObj_Item_Withdraw:SetParent(GUI_LootObj_Inv_Item_Panel)
					GUI_LootObj_Item_Withdraw:SetPos(10,100)
					GUI_LootObj_Item_Withdraw:SetSize(100,15)
					GUI_LootObj_Item_Withdraw:SetText("")
					GUI_LootObj_Item_Withdraw.Paint = function()
													draw.RoundedBox(4,0,0,GUI_LootObj_Item_Withdraw:GetWide(),GUI_LootObj_Item_Withdraw:GetTall(),Color( 60, 60, 60, 155 ))
													draw.RoundedBox(4,1,1,GUI_LootObj_Item_Withdraw:GetWide()-2,GUI_LootObj_Item_Withdraw:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
													
													local struc = {}
													struc.pos = {}
													struc.pos[1] = 50 -- x pos
													struc.pos[2] = 7 -- y pos
													struc.color = Color(255,255,255,255) -- Red
													struc.text = "Loot" -- Text
													struc.font = "UIBold" -- Font
													struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
													struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
													draw.Text( struc )
												end
												
					GUI_LootObj_Item_Withdraw.DoClick = function()
													GUI_Looting(item,OCRP_Object)
												end					
					GUI_LootObj_Inv_Panel_List:AddItem(GUI_LootObj_Inv_Item_Panel)
				end
			end
		end
	end
	
	Inv_Icon_ent:Remove()
	
	return GUI_LootObj_Inv_Panel_List

end
concommand.Add("OCRP_Loot",function(ply,cmd,args) 	if GUI_LootObj_Inv_Panel_List != nil && GUI_LootObj_Inv_Panel_List:IsValid() then return end GUI_LootObj_Inventory() end)

function GUI_Reload_LootObj_LP_Inventory(parent)
	if GUI_LootObj_LP_Panel_List != nil && GUI_LootObj_LP_Panel_List:IsValid() then
		GUI_LootObj_LP_Panel_List:Clear()
		GUI_Weight_LP_Bevel:Remove()
	else
		GUI_LootObj_LP_Panel_List = vgui.Create("DPanelList")
		GUI_LootObj_LP_Panel_List:SetParent(parent)
		GUI_LootObj_LP_Panel_List:SetSize(385,480)
		GUI_LootObj_LP_Panel_List:SetPos(10,20)
		GUI_LootObj_LP_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_LootObj_LP_Panel_List:GetWide(),GUI_LootObj_LP_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
	end

		GUI_LootObj_LP_Panel_List:SetPadding(7.5)
		GUI_LootObj_LP_Panel_List:SetSpacing(2)
		GUI_LootObj_LP_Panel_List:EnableHorizontal(3)
		GUI_LootObj_LP_Panel_List:EnableVerticalScrollbar(true)

	GUI_Weight_LP_Bevel = vgui.Create("DBevel")
	GUI_Weight_LP_Bevel:SetParent(parent)
	GUI_Weight_LP_Bevel:SetSize(385,18)
	GUI_Weight_LP_Bevel:SetPos(10,505)
	GUI_Weight_LP_Bevel.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Weight_LP_Bevel:GetWide(),GUI_Weight_LP_Bevel:GetTall(),Color( 60, 60, 60, 255 ))
								if (GUI_Weight_LP_Bevel:GetWide()*(OCRP_Inventory.WeightData.Cur/OCRP_Inventory.WeightData.Max)) > 8 then
									draw.RoundedBox(8,1,1,(GUI_Weight_LP_Bevel:GetWide()*(OCRP_Inventory.WeightData.Cur/OCRP_Inventory.WeightData.Max))-1,GUI_Weight_LP_Bevel:GetTall()-1,Color( 200, 200, 200, 255 ))
								end
							end
	GUI_Weight_LP_Bevel.PaintOver = function() 
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 185 -- x pos
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
					local GUI_LootObj_LP_Item_Panel = vgui.Create("DPanelList")
					GUI_LootObj_LP_Item_Panel:SetParent(GUI_LootObj_LP_Panel_List)
					GUI_LootObj_LP_Item_Panel:SetSize(120,120)
					GUI_LootObj_LP_Item_Panel:SetPos(0,0)
					GUI_LootObj_LP_Item_Panel:SetSpacing(5)
					GUI_LootObj_LP_Item_Panel.Paint = function()
												draw.RoundedBox(8,0,0,GUI_LootObj_LP_Item_Panel:GetWide(),GUI_LootObj_LP_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
												end
				
					local GUI_LootObj_LP_Item_Icon = vgui.Create("DModelPanel")
					GUI_LootObj_LP_Item_Icon:SetParent(GUI_LootObj_LP_Item_Panel)
					GUI_LootObj_LP_Item_Icon:SetPos(10,10)
					GUI_LootObj_LP_Item_Icon:SetSize(WidthSize,WidthSize)
					
					GUI_LootObj_LP_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
					
					Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
					
					if GAMEMODE.OCRP_Items[item].Angle != nil then
						GUI_LootObj_LP_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
					end

					if GAMEMODE.OCRP_Items[item].Material != nil then
						GUI_LootObj_LP_Item_Icon:GetEntity():SetMaterial(GAMEMODE.OCRP_Items[item].Material)
					end
					
					local center = Inv_Icon_ent:OBBCenter()
					local dist = Inv_Icon_ent:BoundingRadius()*1.2
					GUI_LootObj_LP_Item_Icon:SetLookAt(center)
					GUI_LootObj_LP_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
				
					local GUI_LootObj_LP_Item_Name = vgui.Create("DLabel")
					GUI_LootObj_LP_Item_Name:SetColor(Color(255,255,255,255))
					GUI_LootObj_LP_Item_Name:SetFont("UIBold")
					GUI_LootObj_LP_Item_Name:SetText(GAMEMODE.OCRP_Items[item].Name)
					GUI_LootObj_LP_Item_Name:SizeToContents()
					GUI_LootObj_LP_Item_Name:SetParent(GUI_LootObj_LP_Item_Panel)
					
					surface.SetFont("UIBold")
					local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Name)
					
					GUI_LootObj_LP_Item_Name:SetPos(60 - x/2,10-y/2)
					
				--[[	local GUI_LootObj_LP_Item_Desc = vgui.Create("DLabel")
					GUI_LootObj_LP_Item_Desc:SetColor(Color(255,255,255,255))
					GUI_LootObj_LP_Item_Desc:SetFont("UIBold")
					GUI_LootObj_LP_Item_Desc:SetText(GAMEMODE.OCRP_Items[item].Desc)
					GUI_LootObj_LP_Item_Desc:SetWrap(true)
					GUI_LootObj_LP_Item_Desc:SetSize(90,40)
					GUI_LootObj_LP_Item_Desc:SetParent(GUI_LootObj_LP_Item_Panel)
					
					surface.SetFont("UIBold")
					local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Desc)
					
					GUI_LootObj_LP_Item_Desc:SetPos(10,110)]]
					
					if amount > 1 then
						local GUI_LootObj_LP_Item_Amt = vgui.Create("DLabel")
						GUI_LootObj_LP_Item_Amt:SetColor(Color(255,255,255,255))
						GUI_LootObj_LP_Item_Amt:SetFont("UIBold")
						GUI_LootObj_LP_Item_Amt:SetText("x"..amount)
						GUI_LootObj_LP_Item_Amt:SizeToContents()
						GUI_LootObj_LP_Item_Amt:SetParent(GUI_LootObj_LP_Item_Panel)
						
						surface.SetFont("UIBold")
						local x,y = surface.GetTextSize("x"..amount)
						
						GUI_LootObj_LP_Item_Amt:SetPos(60 - x/2,25-y/2)
					end
						
					local GUI_LootObj_LP_Item_Deposit = vgui.Create("DButton")
					GUI_LootObj_LP_Item_Deposit:SetParent(GUI_LootObj_LP_Item_Panel)
					GUI_LootObj_LP_Item_Deposit:SetPos(10,100)
					GUI_LootObj_LP_Item_Deposit:SetSize(100,15)
					GUI_LootObj_LP_Item_Deposit:SetText("")
					GUI_LootObj_LP_Item_Deposit.Paint = function()
													draw.RoundedBox(4,0,0,GUI_LootObj_LP_Item_Deposit:GetWide(),GUI_LootObj_LP_Item_Deposit:GetTall(),Color( 60, 60, 60, 155 ))
													draw.RoundedBox(4,1,1,GUI_LootObj_LP_Item_Deposit:GetWide()-2,GUI_LootObj_LP_Item_Deposit:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
													
													local struc = {}
													struc.pos = {}
													struc.pos[1] = 50 -- x pos
													struc.pos[2] = 7 -- y pos
													struc.color = Color(255,255,255,255) -- Red
													struc.text = "Give" -- Text
													struc.font = "UIBold" -- Font
													struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
													struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
													draw.Text( struc )
												end
												
					GUI_LootObj_LP_Item_Deposit.DoClick = function()
													RunConsoleCommand("OCRP_DepositItem",item,OCRP_Object:EntIndex()) 
												end
					
				GUI_LootObj_LP_Panel_List:AddItem(GUI_LootObj_LP_Item_Panel)
		end
	end
	
	Inv_Icon_ent:Remove()
	
	return GUI_LootObj_LP_Panel_List
end

function GUI_Looting(item,obj)
	if GUI_Loot_1 != nil && GUI_Loot_1:IsValid() then return end
	LOOTING = true
	RunConsoleCommand("OCRP_BeginLooting",item,obj:EntIndex())
	GUI_Loot_1 = vgui.Create("DBevel")
	GUI_Loot_1:SetSize(500,25)
	GUI_Loot_1:Center()
	GUI_Loot_1:MakePopup()
	GUI_Loot_1.Paint = function()
							draw.RoundedBox(0,0,0,GUI_Loot_1:GetWide(),GUI_Loot_1:GetTall(),Color( 60, 60, 60, 255 ))
						end
	GUI_Loot_2 = vgui.Create("DBevel",GUI_Loot_1)
	GUI_Loot_2:SetSize(5,25	)
	GUI_Loot_2:SetPos(0,0)
	GUI_Loot_2.Paint = function()
							draw.RoundedBox(0,0,0,GUI_Loot_1:GetWide(),GUI_Loot_1:GetTall(),Color( 0, 255, 0, 255 ))
							surface.SetDrawColor(255, 0, 0, 255)
							surface.SetMaterial(Gradient)
							surface.DrawTexturedRect(0,0,GUI_Loot_1:GetWide(),GUI_Loot_1:GetTall())
						end
	GUI_Loot_2.Think = function()
							GUI_Loot_2:SetSize(GUI_Loot_2:GetWide() + (GAMEMODE.OCRP_Items[item].LootData.Speed),100)
							if !OCRP_Object:IsValid() then
								GUI_Loot_1:Remove()
								LOOTING = false
								GUI_LootObj_Inv_Frame:Remove()
								return
							end
							if GUI_Loot_2:GetWide() >= 500 then
								GUI_Loot_1:Remove()
								LOOTING = false
								RunConsoleCommand("OCRP_LootItem",item,obj:EntIndex()) 
							end
						end
	GUI_Loot_1.PaintOver = function() 
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 250 -- x pos
									struc.pos[2] = 12.5 -- y pos
									struc.color = Color( 255, 255, 255, 255 ) -- Red
									struc.font = "UIBold" -- Font
									struc.text = "Looting" -- Text
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )	
							end
end

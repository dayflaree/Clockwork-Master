function GUI_Crafting_Menu()
	if GUI_Crafting_Frame != nil && GUI_Crafting_Frame:IsValid() then return end
	GUI_Crafting_Frame = vgui.Create("DFrame")
	GUI_Crafting_Frame:SetSize(930,600)
	GUI_Crafting_Frame:SetPos(ScrW()/16,ScrH()/16)
	GUI_Crafting_Frame:SetTitle("Crafting Menu")
	GUI_Crafting_Frame:MakePopup()
	GUI_Crafting_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Crafting_Frame:GetWide()-2,GUI_Crafting_Frame:GetTall()-2,OCRP_Options.Color)
							end
	GUI_Crafting_Frame:MakePopup()
	GUI_Crafting_Frame:ShowCloseButton(false)
	
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Crafting_Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(910,0)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()
							GUI_Crafting_Frame:Remove()
								if GUI_Bevel1 != nil && GUI_Bevel1:IsValid() then 
									CRAFTING = false
									GUI_Bevel1:Remove() 
								end
							end
	
	local GUI_Property_Sheet = vgui.Create("DPropertySheet")
	GUI_Property_Sheet:SetParent(GUI_Crafting_Frame)
	GUI_Property_Sheet:SetPos(10,20)
	GUI_Property_Sheet:SetSize(900,584 )
	GUI_Property_Sheet.Paint = function() 

								end		
								

	
		local GUI_Crafting_List_wep = vgui.Create("DPanelList")
		GUI_Crafting_List_wep:SetParent(GUI_Crafting_Frame)
		GUI_Crafting_List_wep:SetSize(900,540)
		GUI_Crafting_List_wep:SetPos(0,0)
		GUI_Crafting_List_wep.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Crafting_List_wep:GetWide(),GUI_Crafting_List_wep:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_Crafting_List_wep:SetPadding(5)
		GUI_Crafting_List_wep:SetSpacing(5)
		GUI_Crafting_List_wep:EnableHorizontal(3)
		GUI_Crafting_List_wep:EnableVerticalScrollbar(true)

		local GUI_Crafting_List_prop = vgui.Create("DPanelList")
		GUI_Crafting_List_prop:SetParent(GUI_Crafting_Frame)
		GUI_Crafting_List_prop:SetSize(900,540)
		GUI_Crafting_List_prop:SetPos(0,0)
		GUI_Crafting_List_prop.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Crafting_List_prop:GetWide(),GUI_Crafting_List_prop:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_Crafting_List_prop:SetPadding(5)
		GUI_Crafting_List_prop:SetSpacing(5)
		GUI_Crafting_List_prop:EnableHorizontal(3)
		GUI_Crafting_List_prop:EnableVerticalScrollbar(true)

		local GUI_Crafting_List_misc = vgui.Create("DPanelList")
		GUI_Crafting_List_misc:SetParent(GUI_Crafting_Frame)
		GUI_Crafting_List_misc:SetSize(900,540)
		GUI_Crafting_List_misc:SetPos(0,0)
		GUI_Crafting_List_misc.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Crafting_List_misc:GetWide(),GUI_Crafting_List_misc:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_Crafting_List_misc:SetPadding(5)
		GUI_Crafting_List_misc:SetSpacing(5)
		GUI_Crafting_List_misc:EnableHorizontal(3)
		GUI_Crafting_List_misc:EnableVerticalScrollbar(true)
		
	GUI_Property_Sheet:AddSheet( "Weapons/Ammo", GUI_Crafting_List_wep, "gui/silkicons/bomb", true, true, "Craft weapons and ammo" )
	GUI_Property_Sheet:AddSheet( "Props", GUI_Crafting_List_prop, "gui/silkicons/bomb", true, true, "Craft barriers and furniture" )
	GUI_Property_Sheet:AddSheet( "Misc.", GUI_Crafting_List_misc, "gui/silkicons/bomb", true, true, "Whatever else is left" )
	
	local WidthSize = 100
														
	local Craft_Icon_ent = ents.Create("prop_physics")

	Craft_Icon_ent:SetPos(Vector(0,0,0))
	Craft_Icon_ent:Spawn()
	Craft_Icon_ent:Activate()	
											
		local parent = GUI_Crafting_List_misc								
		for _,data in pairs(GAMEMODE.OCRP_Recipies) do
	
			if data.Cata == "Wep" then										
				parent = GUI_Crafting_List_wep
			elseif data.Cata == "Prop" then	
				parent = GUI_Crafting_List_prop
			else
				parent = GUI_Crafting_List_misc
			end
	
			local GUI_Craft_Item_Panel = vgui.Create("DPanel")
			GUI_Craft_Item_Panel:SetParent(parent)
			GUI_Craft_Item_Panel:SetSize(120,130)
			GUI_Craft_Item_Panel:SetPos(0,0)
			GUI_Craft_Item_Panel.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Craft_Item_Panel:GetWide(),GUI_Craft_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end

			local GUI_Craft_Item_Icon = vgui.Create("DModelPanel")
			GUI_Craft_Item_Icon:SetParent(GUI_Craft_Item_Panel)
			GUI_Craft_Item_Icon:SetPos(10,10)
			GUI_Craft_Item_Icon:SetSize(WidthSize,WidthSize)
			
			GUI_Craft_Item_Icon:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
			
			Craft_Icon_ent:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
			
			if GAMEMODE.OCRP_Items[data.Item].Angle != nil then
				GUI_Craft_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[data.Item].Angle)
			end
			
			local center = Craft_Icon_ent:OBBCenter()
			local dist = Craft_Icon_ent:BoundingRadius()*1.2
			GUI_Craft_Item_Icon:SetLookAt(center)
			GUI_Craft_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	

			GUI_Craft_Item_Icon.OnCursorEntered = function()
												if data.Cata == "Wep" then										
													parent = GUI_Crafting_List_wep
												elseif data.Cata == "Prop" then	
													parent = GUI_Crafting_List_prop
												else
													parent = GUI_Crafting_List_misc
												end
			
												GUI_Crafting_Skill_Panel = vgui.Create("DPanel")
												GUI_Crafting_Skill_Panel:SetParent(parent)
												GUI_Crafting_Skill_Panel.Paint = function() 
																				draw.RoundedBox(8,0,0,GUI_Crafting_Skill_Panel:GetWide(),GUI_Crafting_Skill_Panel:GetTall(),Color( 60, 60, 60, 255 )) 
																			end
												
												local GUI_Crafting_Skill_Title = vgui.Create("DLabel")
												GUI_Crafting_Skill_Title:SetParent(GUI_Crafting_Skill_Panel)
												GUI_Crafting_Skill_Title:SetPos(5,5)
												GUI_Crafting_Skill_Title:SetColor(Color(255,255,255,255))
												GUI_Crafting_Skill_Title:SetText("Skill Requirements:")
												GUI_Crafting_Skill_Title:SetFont("Trebuchet20")
												GUI_Crafting_Skill_Title:SizeToContents()
												
												local num = 10
												local num1 = GUI_Crafting_Skill_Title:GetWide()
												for skill,level in pairs(data.Skills) do
													if level > 0 then
														local COL = Color(255,255,255,255)
														if !CL_HasSkill(skill,level) then
															COL = Color(255,55,55,255)
														end
														local GUI_Crafting_Skill_Title = vgui.Create("DLabel")
														GUI_Crafting_Skill_Title:SetParent(GUI_Crafting_Skill_Panel)
														GUI_Crafting_Skill_Title:SetPos(15,15 + num)
														GUI_Crafting_Skill_Title:SetColor(COL)
														GUI_Crafting_Skill_Title:SetText("Requires : "..GAMEMODE.OCRP_Skills[tostring(skill)].Name.." level "..level)
														GUI_Crafting_Skill_Title:SetFont("Trebuchet18")
														GUI_Crafting_Skill_Title:SizeToContents()	
														if GUI_Crafting_Skill_Title:GetWide() > num1 then
															num1 = GUI_Crafting_Skill_Title:GetWide() 
														end
														num = num + 15
													end
												end
												
												num = num + 15
												
												local GUI_Label_Requirements = vgui.Create("DLabel")
												GUI_Label_Requirements:SetColor(Color(255,255,255,255))
												GUI_Label_Requirements:SetFont("Trebuchet20")
												GUI_Label_Requirements:SetText("Items Required: ")
												GUI_Label_Requirements:SizeToContents()
												GUI_Label_Requirements:SetParent(GUI_Crafting_Skill_Panel)
												GUI_Label_Requirements:SetPos(5,5 + num)
												
												num = num + 15
												
												for _,data1 in pairs(data.Requirements) do
													local COL = Color(255,255,255,255)
													if !CL_HasItem(data1.Item,data1.Amount) then
														COL = Color(155,55,55,255)
													end
													local GUI_Item_RequireMent = vgui.Create("DLabel")
													GUI_Item_RequireMent:SetColor(COL)
													GUI_Item_RequireMent:SetFont("Trebuchet18")
													GUI_Item_RequireMent:SetText(GAMEMODE.OCRP_Items[data1.Item].Name.." x"..data1.Amount)
													GUI_Item_RequireMent:SizeToContents()
													GUI_Item_RequireMent:SetParent(GUI_Crafting_Skill_Panel)
													GUI_Item_RequireMent:SetPos(15,15+num)	
													
													if GUI_Item_RequireMent:GetWide() > num1 then
														num1 = GUI_Crafting_Skill_Title:GetWide() 
													end		
													
													num = num + 15
													
												end
												
												GUI_Crafting_Skill_Panel:SetSize(num1 + 20,num + 25)
												local x,y = GUI_Craft_Item_Panel:GetPos()
												local xpos,ypos = (x + GUI_Crafting_Skill_Panel:GetWide()/2 + 15),(y + GUI_Crafting_Skill_Panel:GetTall() + 15)
												if xpos + GUI_Crafting_Skill_Panel:GetWide() > parent:GetWide() then
													xpos = (x - GUI_Crafting_Skill_Panel:GetWide()/2)
												end
												if ypos + GUI_Crafting_Skill_Panel:GetTall() > parent:GetTall() then
													ypos = (y - GUI_Crafting_Skill_Panel:GetTall())
												end
												GUI_Crafting_Skill_Panel:SetPos(xpos ,ypos)
											end
			GUI_Craft_Item_Icon.OnCursorExited = function()
											GUI_Crafting_Skill_Panel:Remove()
										end			
			
			
			local GUI_Craft_Item_Name = vgui.Create("DLabel")
			GUI_Craft_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Craft_Item_Name:SetFont("UIBold")
			GUI_Craft_Item_Name:SetText(GAMEMODE.OCRP_Items[data.Item].Name)
			GUI_Craft_Item_Name:SizeToContents()
			GUI_Craft_Item_Name:SetParent(GUI_Craft_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[data.Item].Name)
			
			GUI_Craft_Item_Name:SetPos(60 - x/2,10-y/2)
			
			local GUI_Craft_Item_Desc = vgui.Create("DLabel")
			GUI_Craft_Item_Desc:SetColor(Color(255,255,255,255))
			GUI_Craft_Item_Desc:SetFont("UIBold")
			GUI_Craft_Item_Desc:SetText(GAMEMODE.OCRP_Items[data.Item].Desc)
			GUI_Craft_Item_Desc:SizeToContents()
			GUI_Craft_Item_Desc:SetParent(GUI_Craft_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[data.Item].Desc)
			
			GUI_Craft_Item_Desc:SetPos(60 - x/2,100-y/2)
			
			if data.Amount != nil && data.Amount > 1 then
				local GUI_Craft_Item_Amt = vgui.Create("DLabel")
				GUI_Craft_Item_Amt:SetColor(Color(255,255,255,255))
				GUI_Craft_Item_Amt:SetFont("UIBold")
				GUI_Craft_Item_Amt:SetText("x"..data.Amount)
				GUI_Craft_Item_Amt:SizeToContents()
				GUI_Craft_Item_Amt:SetParent(GUI_Craft_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("x"..data.Amount)
				
				GUI_Craft_Item_Amt:SetPos(60 - x/2,25-y/2)
			end

			if data.HeatSource != nil && data.HeatSource then
				local GUI_Craft_Heat = vgui.Create("DLabel")
				GUI_Craft_Heat:SetColor(Color(255,100,100,255))
				GUI_Craft_Heat:SetFont("UIBold")
				GUI_Craft_Heat:SetText("Furnace Required")
				GUI_Craft_Heat:SizeToContents()
				GUI_Craft_Heat:SetParent(GUI_Craft_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("Furnace Required")
				
				GUI_Craft_Heat:SetPos(60 - x/2,30-y/2)
			end
			if data.WaterSource != nil && data.WaterSource then
				local GUI_Craft_Water = vgui.Create("DLabel")
				GUI_Craft_Water:SetColor(Color(100,100,255,255))
				GUI_Craft_Water:SetFont("UIBold")
				GUI_Craft_Water:SetText("Sink Required")
				GUI_Craft_Water:SizeToContents()
				GUI_Craft_Water:SetParent(GUI_Craft_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("Water Source Required")
				
				GUI_Craft_Water:SetPos(60 - x/2,50-y/2)		
			end
			if data.Explosive != nil && data.Explosive then
				local GUI_Craft_Explosive = vgui.Create("DLabel")
				GUI_Craft_Explosive:SetColor(Color(255,150,90,255))
				GUI_Craft_Explosive:SetFont("UIBold")
				GUI_Craft_Explosive:SetText("WARNING Explosive")
				GUI_Craft_Explosive:SizeToContents()
				GUI_Craft_Explosive:SetParent(GUI_Craft_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("WARNING Explosive")
				
				GUI_Craft_Explosive:SetPos(60 - x/2,50-y/2)			
			end
					
				local GUI_Craft_Item_Craft = vgui.Create("DButton")
				GUI_Craft_Item_Craft:SetParent(GUI_Craft_Item_Panel)
				GUI_Craft_Item_Craft:SetPos(5,115)
				GUI_Craft_Item_Craft:SetSize(110,10)
				GUI_Craft_Item_Craft:SetText("")
				GUI_Craft_Item_Craft.Paint = function()			
												local bool = true 
												for skill,level in pairs(data.Skills) do
													if !CL_HasSkill(skill,level)  then
														bool = false
													end
												end
												

												if bool then
												draw.RoundedBox(4,0,0,GUI_Craft_Item_Craft:GetWide(),GUI_Craft_Item_Craft:GetTall(),Color( 60, 60, 60, 155 ))
												draw.RoundedBox(4,1,1,GUI_Craft_Item_Craft:GetWide()-2,GUI_Craft_Item_Craft:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												local COL = Color(255,255,255,255)
												for _,data1 in pairs(data.Requirements) do
													if !CL_HasItem(data1.Item,data1.Amount) then
														COL = Color(155,55,55,255)
													end
												end

												local struc = {}
												struc.pos = {}
												struc.pos[1] = 55 -- x pos
												struc.pos[2] = 5 -- y pos
												struc.color = COL -- Red
												struc.font = "UIBold" -- Font
												struc.text = "Craft" -- Text
												struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
												struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
												draw.Text( struc )											
		else
												local struc = {}
												struc.pos = {}
												struc.pos[1] = 55 -- x pos
												struc.pos[2] = 5 -- y pos
												struc.color = Color( 255, 255, 30, 155 ) -- Red
												struc.font = "UIBold" -- Font
												struc.text = "" -- Text
												struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
												struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
												draw.Text( struc )
							
												end
											end
		GUI_Craft_Item_Craft.DoClick = function()
												if CRAFTING then return end
												local bool = true 
												for skill,level in pairs(data.Skills) do
													if !CL_HasSkill(skill,level) then
														bool = false
													end
												end
												for _,data1 in pairs(data.Requirements) do
													if !CL_HasItem(data1.Item,data1.Amount) then
														bool = false
													end
												end
												if bool then
													GUI_Crafting(data.Item)
												end
											end
											
								
											parent:AddItem(GUI_Craft_Item_Panel)
										end
												
	Craft_Icon_ent:Remove()	
	
	for _,panel in pairs(GUI_Property_Sheet.Items) do
		panel.Tab:SetAutoStretchVertical(false)
		panel.Tab:SetSize(50,50)
		panel.Tab.Paint = function() 
							draw.RoundedBox(8,0,0,panel.Tab:GetWide()-4,panel.Tab:GetTall()+10,Color( 60, 60, 60, 155 ))
						end
	end	
end
concommand.Add("OCRP_CraftingMenu", function() GUI_Crafting_Menu() end )

function GUI_Crafting(item)
	if GUI_Bevel1 != nil && GUI_Bevel1:IsValid() then return end
	CRAFTING = true
	GUI_Bevel1 = vgui.Create("DBevel")
	GUI_Bevel1:SetSize(250,25)
	GUI_Bevel1:Center()
	GUI_Bevel1:MakePopup()
	GUI_Bevel1.Paint = function()
							draw.RoundedBox(0,0,0,GUI_Bevel1:GetWide(),GUI_Bevel1:GetTall(),Color( 60, 60, 60, 255 ))
						end
	GUI_Crafting_Bevel = vgui.Create("DBevel",GUI_Bevel1)
	GUI_Crafting_Bevel:SetSize(5,25	)
	GUI_Crafting_Bevel:SetPos(0,0)
	GUI_Crafting_Bevel.Paint = function()
							draw.RoundedBox(0,0,0,GUI_Bevel1:GetWide(),GUI_Bevel1:GetTall(),Color( 0, 255, 0, 255 ))
							surface.SetDrawColor(255, 0, 0, 255)
							surface.SetMaterial(Gradient)
							surface.DrawTexturedRect(0,0,GUI_Bevel1:GetWide(),GUI_Bevel1:GetTall())
						end
	GUI_Crafting_Bevel.Think = function()
							GUI_Crafting_Bevel:SetSize(GUI_Crafting_Bevel:GetWide() + 2.5,100)
							if GUI_Crafting_Bevel:GetWide() >= 250 then
								GUI_Bevel1:Remove()
								CRAFTING = false
								RunConsoleCommand("OCRP_CraftItem",item) 
							end
						end
	GUI_Bevel1.PaintOver = function() 
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 125 -- x pos
									struc.pos[2] = 12.5 -- y pos
									struc.color = Color( 255, 255, 255, 255 ) -- Red
									struc.font = "UIBold" -- Font
									struc.text = "Crafting" -- Text
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )	
							end
end

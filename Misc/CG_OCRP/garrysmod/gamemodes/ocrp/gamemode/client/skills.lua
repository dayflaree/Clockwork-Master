
function CL_UpdateSkill( umsg )
	local skill = umsg:ReadString()
	local level = umsg:ReadLong()
	local points = umsg:ReadLong() 

	OCRP_Skills.Points = points
	OCRP_Skills[skill] = level
	
	if GUI_Main_Frame != nil && GUI_Main_Frame:IsValid() then
		GUI_Rebuild_Skills(GUI_Skill_tab_Panel)
	end
end
usermessage.Hook('OCRP_UpdateSkill', CL_UpdateSkill);


function GUI_Rebuild_Skills(parent)
	if GUI_Skill_Panel_List != nil && GUI_Skill_Panel_List:IsValid() then
		GUI_Skill_Panel_List:Remove()
		GUI_Skill_Points_Panel:Remove()
	end
	GUI_Skill_Panel_List = vgui.Create("DPanelList")
	GUI_Skill_Panel_List:SetParent(parent)
	GUI_Skill_Panel_List:SetSize(746,430)
	GUI_Skill_Panel_List:SetPos(0,0)
	GUI_Skill_Panel_List.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Skill_Panel_List:GetWide(),GUI_Skill_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
	GUI_Skill_Panel_List:SetPadding(5)
	GUI_Skill_Panel_List:EnableHorizontal(true)
	GUI_Skill_Panel_List:SetSpacing(5)
	
	local Skill_Icon_ent = ents.Create("prop_physics")

	Skill_Icon_ent:SetPos(Vector(0,0,0))
	Skill_Icon_ent:Spawn()
	Skill_Icon_ent:Activate()	
	
	GUI_Skill_Points_Panel = vgui.Create("DPanel")
	GUI_Skill_Points_Panel:SetParent(parent)
	GUI_Skill_Points_Panel.Paint = function() 
									draw.RoundedBox(8,0,0,GUI_Skill_Points_Panel:GetWide(),GUI_Skill_Points_Panel:GetTall(),Color( 60, 60, 60, 155 )) 
								end	
	GUI_Skill_Points_Panel:SetPos(10,440)
	GUI_Skill_Points_Panel:SetSize(300,30)
	
	local GUI_Skill_Points = vgui.Create("DLabel")
	GUI_Skill_Points:SetParent(GUI_Skill_Points_Panel)
	GUI_Skill_Points:SetPos(5,5)
	GUI_Skill_Points:SetColor(Color(255,255,255,255))
	GUI_Skill_Points.Think = function()
										GUI_Skill_Points:SetText("You have "..OCRP_Skills.Points.." Skill points remaining.")
							end
	GUI_Skill_Points:SetFont("Trebuchet22")
	GUI_Skill_Points:SetSize(290,20)
	GUI_Skill_Points:SetWrap(true)
	local skillcount = 0 
	for skill,level in pairs(OCRP_Skills) do
		if skill != "Points" && level > 0 then
			local GUI_Skill_Panel = vgui.Create("DPanel")
			GUI_Skill_Panel:SetParent(GUI_Skill_Panel_List)
			GUI_Skill_Panel:SetSize(100,100)
			GUI_Skill_Panel:SetPos(10,10)
			GUI_Skill_Panel.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Skill_Panel:GetWide(),GUI_Skill_Panel:GetTall(),Color( 60, 60, 60, 155 ))
									end
			local GUI_Skill_Icon = vgui.Create("DModelPanel")
			GUI_Skill_Icon:SetParent(GUI_Skill_Panel)
			GUI_Skill_Icon:SetSize(80,80)
			
			GUI_Skill_Icon:SetModel(GAMEMODE.OCRP_Skills[skill].Model)
				
			Skill_Icon_ent:SetModel(GAMEMODE.OCRP_Skills[skill].Model)
						
			local center = Skill_Icon_ent:OBBCenter()
			local dist = Skill_Icon_ent:BoundingRadius()*1.5
			GUI_Skill_Icon:SetLookAt(center)
			GUI_Skill_Icon:SetCamPos(center+Vector(dist,dist,0))	

			GUI_Skill_Icon.OnCursorEntered = function()
												GUI_Skill_Stats_Panel = vgui.Create("DPanel")
												GUI_Skill_Stats_Panel:SetParent(GUI_Skill_Panel_List)
												GUI_Skill_Stats_Panel.Paint = function() 
																				draw.RoundedBox(8,0,0,GUI_Skill_Stats_Panel:GetWide(),GUI_Skill_Stats_Panel:GetTall(),Color( 60, 60, 60, 255 )) 
																			end
												
												local GUI_Skill_Stat_Title = vgui.Create("DLabel")
												GUI_Skill_Stat_Title:SetParent(GUI_Skill_Stats_Panel)
												GUI_Skill_Stat_Title:SetPos(5,5)
												GUI_Skill_Stat_Title:SetColor(Color(255,255,255,255))
												GUI_Skill_Stat_Title:SetText("Your Character Recieves:")
												GUI_Skill_Stat_Title:SetFont("Trebuchet20")
												GUI_Skill_Stat_Title:SizeToContents()
												
												local num = 10
												local num1 = GUI_Skill_Stat_Title:GetWide()
												for i = 1,level do
													if GAMEMODE.OCRP_Skills[skill].LvlDesc[i] != nil then
														local GUI_Skill_Stat_Title = vgui.Create("DLabel")
														GUI_Skill_Stat_Title:SetParent(GUI_Skill_Stats_Panel)
														GUI_Skill_Stat_Title:SetPos(15,15 + num)
														GUI_Skill_Stat_Title:SetColor(Color(200,200,200,255))
														GUI_Skill_Stat_Title:SetText(GAMEMODE.OCRP_Skills[skill].LvlDesc[i])
														GUI_Skill_Stat_Title:SetFont("Trebuchet18")
														GUI_Skill_Stat_Title:SizeToContents()	
														if GUI_Skill_Stat_Title:GetWide() > num1 then
															num1 = GUI_Skill_Stat_Title:GetWide() 
														end
														num = num + 15
													end
												end
												GUI_Skill_Stats_Panel:SetSize(num1 + 20,num + 25)
												local x,y = GUI_Skill_Panel:GetPos()
												local xpos,ypos = (x + GUI_Skill_Stats_Panel:GetWide()/2),(y + GUI_Skill_Stats_Panel:GetTall())
												if xpos + GUI_Skill_Stats_Panel:GetWide() > GUI_Skill_Panel_List:GetWide() then
													xpos = (x - GUI_Skill_Stats_Panel:GetWide()/2)
												end
												if ypos + GUI_Skill_Stats_Panel:GetTall() > GUI_Skill_Panel_List:GetTall() then
													ypos = (y - GUI_Skill_Stats_Panel:GetTall())
												end
												GUI_Skill_Stats_Panel:SetPos(xpos ,ypos)
											end
			GUI_Skill_Icon.OnCursorExited = function()
											GUI_Skill_Stats_Panel:Remove()
										end
			
			local GUI_Skill_Name = vgui.Create("DLabel")
			GUI_Skill_Name:SetParent(GUI_Skill_Panel)
			GUI_Skill_Name:SetPos(5,5)
			GUI_Skill_Name:SetColor(Color(255,255,255,255))
			GUI_Skill_Name:SetText(GAMEMODE.OCRP_Skills[skill].Name)
			GUI_Skill_Name:SetFont("UIBold")
			GUI_Skill_Name:SetSize(90,30)
			GUI_Skill_Name:SetWrap(true)

			local GUI_Skill_Level = vgui.Create("DLabel")
			GUI_Skill_Level:SetParent(GUI_Skill_Panel)
			GUI_Skill_Level:SetPos(5,85)
			GUI_Skill_Level:SetText("Level "..level.."/"..GAMEMODE.OCRP_Skills[skill].MaxLevel)
			GUI_Skill_Level:SetFont("UIBold")
			GUI_Skill_Level:SizeToContents()
			
			if level < GAMEMODE.OCRP_Skills[skill].MaxLevel then
				local GUI_Skill_Level = vgui.Create("DImage")
				GUI_Skill_Level:SetParent(GUI_Skill_Panel)
				GUI_Skill_Level:SetPos(70,75)
				GUI_Skill_Level:SetMaterial(OC_Plus)
				GUI_Skill_Level:SetSize(25,25)	

				local GUI_Skill_Level = vgui.Create("DButton")
				GUI_Skill_Level:SetParent(GUI_Skill_Panel)
				GUI_Skill_Level:SetPos(70,75)
				GUI_Skill_Level:SetSize(25,25)	
				if GAMEMODE.OCRP_Skills[skill].LvlDesc[level + 1] != nil then
					GUI_Skill_Level:SetToolTip("Next Level: "..GAMEMODE.OCRP_Skills[skill].LvlDesc[level + 1])
				end
				GUI_Skill_Level:SetText("")
				GUI_Skill_Level.Paint = function() end
				GUI_Skill_Level.DoClick = function() 
												if OCRP_Skills.Points >= 1 then
													RunConsoleCommand("OCRP_UpgradeSkill",skill)
												end
											end										
			end
			GUI_Skill_Panel_List:AddItem(GUI_Skill_Panel)
			skillcount = skillcount + 1
		end
	end

	for i = 1, 28-skillcount do
		local GUI_Skill_Panel = vgui.Create("DPanel")
		GUI_Skill_Panel:SetParent(GUI_Skill_Panel_List)
		GUI_Skill_Panel:SetSize(100,100)
		GUI_Skill_Panel:SetPos(0,0)
		GUI_Skill_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Skill_Panel:GetWide(),GUI_Skill_Panel:GetTall(),Color( 60, 60, 60, 155 ))
								end
		GUI_Skill_Panel_List:AddItem(GUI_Skill_Panel)
	end

	Skill_Icon_ent:Remove()		
end

function CL_HasSkill(skill,level)
	if level == nil then level = 1 end
	if OCRP_Skills[skill] != nil then
		if OCRP_Skills[skill] >= level then
			return true
		end
	end
	return false
end

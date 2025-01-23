--TODO
local draw = draw
local vgui = vgui
local CurOption = 1

function CL_CreateChat( umsg )
	local string1 = umsg:ReadString()
	local bool = umsg:ReadBool()
	if bool then
		GUI_ShopMenu(string1)
	else
		GUI_JobMenu(string1)
	end
end
usermessage.Hook('OCRP_CreateChat', CL_CreateChat);

function GUI_JobMenu1(JobId)

	CurOption = 1
	
	GUI_Job_Frame = vgui.Create("DFrame")
	GUI_Job_Frame:SetTitle("")
	GUI_Job_Frame:SetSize(590 ,200)
	GUI_Job_Frame:Center()
	GUI_Job_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Job_Frame:GetWide(),GUI_Job_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Job_Frame:GetWide()-2,GUI_Job_Frame:GetTall()-2,OCRP_Options.Color)
								draw.RoundedBox(8,200,10,380,78.5,Color(90,90,90,155))
								draw.RoundedBox(8,200,92.5,380,97.5,Color(90,90,90,155))																
								draw.RoundedBox(8,10,10,180,180,Color(90,90,90,155))		
								
								--[[surface.SetTextColor(255,255,255,255)
								surface.SetFont("Trebuchet24")
								local x,y = surface.GetTextSize(GAMEMODE.OCRP_Shops[shopid].Name)
								surface.SetTextPos(10,11 - y/2)
								surface.DrawText(GAMEMODE.OCRP_Shops[shopid].Name)]]--
							end
	GUI_Job_Frame:MakePopup()
	GUI_Job_Frame:ShowCloseButton(false)
	
	local GUI_Npc_Model_Icon = vgui.Create("DModelPanel")
	GUI_Npc_Model_Icon:SetParent(GUI_Job_Frame)
	GUI_Npc_Model_Icon:SetPos(10,10)
	GUI_Npc_Model_Icon:SetSize(180,180)
			
	local tr = LocalPlayer():GetEyeTrace()
	GUI_Npc_Model_Icon:SetModel(tr.Entity:GetModel())
	GUI_Npc_Model_Icon:SetCamPos(Vector(14, 0, 62))
	GUI_Npc_Model_Icon:SetLookAt(Vector(0,0,66))
	GUI_Npc_Model_Icon:SetFOV(70)
	
	function GUI_Npc_Model_Icon:LayoutEntity( Entity )
		self:SetCamPos(Vector(14, 0, 62))
		self:SetLookAt(Vector(0,0,66))		
	end
	
	if GAMEMODE.OCRP_Dialogue[JobId].Condition != nil then 
		if GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) == true then
			if GAMEMODE.OCRP_Dialogue[JobId].Function != nil then
				if GAMEMODE.OCRP_Dialogue[JobId].Function(LocalPlayer()) == "Exit" then
					GUI_Job_Frame:Remove()
					return
				end
			CurOption = GAMEMODE.OCRP_Dialogue[JobId].Function(LocalPlayer())
			end
		elseif GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) != true && GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) != false then
			CurOption = GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer())
		elseif GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) == "Exit" then
			GUI_Job_Frame:Remove()
			return
		end
	end
	
	GUI_Rebuild_Dialogue(GUI_Job_Frame,JobId)
	
end
concommand.Add("GUI_JobMenua", GUI_JobMenu1)


function GUI_JobMenu(JobId)

	
	CurOption = 1
	
	GUI_Job_Frame = vgui.Create("DFrame")
	GUI_Job_Frame:SetTitle("")
	GUI_Job_Frame:SetSize(590 ,200)
	GUI_Job_Frame:Center()
	GUI_Job_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Job_Frame:GetWide(),GUI_Job_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Job_Frame:GetWide()-2,GUI_Job_Frame:GetTall()-2,OCRP_Options.Color)
								draw.RoundedBox(8,200,10,380,78.5,Color(90,90,90,155))
								draw.RoundedBox(8,200,92.5,380,97.5,Color(90,90,90,155))																
								draw.RoundedBox(8,10,10,180,180,Color(90,90,90,155))									
								--[[surface.SetTextColor(255,255,255,255)
								surface.SetFont("Trebuchet24")
								local x,y = surface.GetTextSize(GAMEMODE.OCRP_Shops[shopid].Name)
								surface.SetTextPos(10,11 - y/2)
								surface.DrawText(GAMEMODE.OCRP_Shops[shopid].Name)]]--
							end
	GUI_Job_Frame:MakePopup()
	GUI_Job_Frame:ShowCloseButton(false)
	
	local GUI_Npc_Model_Icon = vgui.Create("DModelPanel")
	GUI_Npc_Model_Icon:SetParent(GUI_Job_Frame)
	GUI_Npc_Model_Icon:SetPos(10,10)
	GUI_Npc_Model_Icon:SetSize(180,180)
			
	GUI_Npc_Model_Icon:SetModel(LocalPlayer():GetModel())
	if string.find(LocalPlayer():GetModel(), "fe") then
		GUI_Npc_Model_Icon:SetCamPos(Vector(14, 0, 62))
	else
		GUI_Npc_Model_Icon:SetCamPos(Vector(14, 0, 60))	
	end
	GUI_Npc_Model_Icon:SetLookAt(Vector(0,0,66))
	GUI_Npc_Model_Icon:SetFOV(70)
	
	function GUI_Npc_Model_Icon:LayoutEntity( Entity )
		if string.find(LocalPlayer():GetModel(), "fe") then
			self:SetCamPos(Vector(14, 0, 62))
		else
			self:SetCamPos(Vector(14, 0, 60))	
		end
		self:SetLookAt(Vector(0,0,66))		
	end
	
	if GAMEMODE.OCRP_Dialogue[JobId].Condition != nil then 
		if GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) == true then
			if GAMEMODE.OCRP_Dialogue[JobId].Function != nil then
				if GAMEMODE.OCRP_Dialogue[JobId].Function(LocalPlayer()) == "Exit" then
					GUI_Job_Frame:Remove()
					return
				end
			CurOption = GAMEMODE.OCRP_Dialogue[JobId].Function(LocalPlayer())
			end
		elseif GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) != true && GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) != false then
			CurOption = GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer())
		elseif GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer()) == "Exit" then
			GUI_Job_Frame:Remove()
			return
		end
	end
	
	GUI_Rebuild_Dialogue(GUI_Job_Frame,JobId)
end

function GUI_Rebuild_Dialogue(parent,JobId)
	if GUI_Dialogue_Panel_List != nil && GUI_Dialogue_Panel_List:IsValid() then
		GUI_Dialogue_Panel_List:Remove()
		GUI_Dialogue_Panel_List = vgui.Create("DPanelList")
		GUI_Dialogue_Panel_List:SetParent(parent)
		GUI_Dialogue_Panel_List:SetSize(parent:GetWide(),parent:GetTall())
		GUI_Dialogue_Panel_List:SetPos(0,0)
		GUI_Dialogue_Panel_List.Paint = function()
									end
		GUI_Dialogue_Panel_List:SetPadding(7.5)
		GUI_Dialogue_Panel_List:SetSpacing(5)
		GUI_Dialogue_Panel_List:EnableHorizontal(6)
		GUI_Dialogue_Panel_List:EnableVerticalScrollbar(true)
	else
		GUI_Dialogue_Panel_List = vgui.Create("DPanelList")
		GUI_Dialogue_Panel_List:SetParent(parent)
		GUI_Dialogue_Panel_List:SetSize(parent:GetWide(),parent:GetTall())
		GUI_Dialogue_Panel_List:SetPos(0,0)
		GUI_Dialogue_Panel_List.Paint = function()
									end
		GUI_Dialogue_Panel_List:SetPadding(7.5)
		GUI_Dialogue_Panel_List:SetSpacing(5)
		GUI_Dialogue_Panel_List:EnableHorizontal(6)
		GUI_Dialogue_Panel_List:EnableVerticalScrollbar(true)
	end
	
	local GUI_Label_Say = vgui.Create("DLabel")
	GUI_Label_Say:SetColor(Color(255,255,255,255))
	GUI_Label_Say:SetFont("UIBold")
	GUI_Label_Say:SetText(GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Question)
	GUI_Label_Say:SizeToContents()
	GUI_Label_Say:SetParent(GUI_Dialogue_Panel_List)
					
	surface.SetFont("UIBold")
	local x,y = surface.GetTextSize(GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Question)
					
	GUI_Label_Say:SetPos(390 - x/2,50-y/2)	
	
	local GUI_Option_Yes = vgui.Create("DButton")
	GUI_Option_Yes:SetParent(GUI_Dialogue_Panel_List)
	GUI_Option_Yes:SetPos(202.5,95)
	GUI_Option_Yes:SetSize(375,44.75)
	GUI_Option_Yes:SetText("")
	GUI_Option_Yes.Paint = function()
														draw.RoundedBox(4,0,0,GUI_Option_Yes:GetWide(),GUI_Option_Yes:GetTall(),Color( 60, 60, 60, 155 ))
														draw.RoundedBox(4,1,1,GUI_Option_Yes:GetWide()-2,GUI_Option_Yes:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
														
														local struc = {}
														struc.pos = {}
														struc.pos[1] = 187.5 -- x pos
														struc.pos[2] = 25 -- y pos
														struc.color = Color(255,255,255,255) -- Red
														struc.text = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].YesAnswer -- Text
														struc.font = "UIBold" -- Font
														struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
														struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
														draw.Text( struc )
													end
	GUI_Option_Yes.DoClick = function() 
								if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition != nil then 
									if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) == true then
										if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function != nil then
											if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function(LocalPlayer()) == "Exit" then
												GUI_Job_Frame:Remove()
												return
											end
											CurOption = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function(LocalPlayer())
										end
									elseif GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) != true && GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) != false then
										CurOption = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer())
									elseif GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) == "Exit" then
										GUI_Job_Frame:Remove()
										return
									end
								end 
								GUI_Rebuild_Dialogue(parent,JobId)
							end
													
													
	local GUI_Option_No = vgui.Create("DButton")
	GUI_Option_No:SetParent(GUI_Dialogue_Panel_List)
	GUI_Option_No:SetPos(202.5,144)
	GUI_Option_No:SetSize(375,44.75)
	GUI_Option_No:SetText("")
	GUI_Option_No.Paint = function()
														draw.RoundedBox(4,0,0,GUI_Option_No:GetWide(),GUI_Option_No:GetTall(),Color( 60, 60, 60, 155 ))
														draw.RoundedBox(4,1,1,GUI_Option_No:GetWide()-2,GUI_Option_No:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
														
														local struc = {}
														struc.pos = {}
														struc.pos[1] = 187.5 -- x pos
														struc.pos[2] = 25 -- y pos
														struc.color = Color(255,255,255,255) -- Red
														struc.text = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].NoAnswer -- Text
														struc.font = "UIBold" -- Font
														struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
														struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
														draw.Text( struc )
													end	
													
	GUI_Option_No.DoClick = function()
	if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].SecondYes then
		if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition != nil then 
			if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) == true then
				if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function2 != nil then
					if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function2(LocalPlayer()) == "Exit" then
						GUI_Job_Frame:Remove()
						return
					end
					CurOption = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function2(LocalPlayer())
				end
			elseif GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) != true && GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) != false then
				CurOption = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer())
			elseif GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer()) == "Exit" then
				GUI_Job_Frame:Remove()
				return
			end
		end 
		GUI_Rebuild_Dialogue(parent,JobId)
	else
		parent:Remove()
	end
	end	
end

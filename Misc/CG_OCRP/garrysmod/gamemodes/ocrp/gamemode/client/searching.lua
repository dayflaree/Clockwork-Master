local vgui = vgui
local draw = draw
local surface = surface

OCRP_Object_Inventory = {WeightData = {Cur = 0, Max = 5}}
OCRP_Object = nil
OCRP_Object_Money = nil

function CL_UpdateObjectItem( umsg )
	local item = umsg:ReadString()
	local amount = umsg:ReadShort()
	local weightcur = umsg:ReadShort()
	local weightmax = umsg:ReadShort()
	local Object = umsg:ReadEntity() 
	OCRP_Object_Inventory.WeightData = {Cur = tonumber(weightcur),Max = tonumber(weightmax)} 
	OCRP_Object_Inventory[tostring(item)] = tonumber(amount)
	OCRP_Object = Object

	if GUI_Object_Inv_Frame != nil && GUI_Object_Inv_Frame:IsValid() then
		GUI_Reload_Object_Inventory(GUI_Object_Inv_Frame)
	elseif GUI_LootObj_Inv_Frame != nil && GUI_LootObj_Inv_Frame:IsValid() then
		GUI_Reload_LootObj_Inventory(GUI_LootObj_Inv_Frame)
	end
end
usermessage.Hook('OCRP_UpdateObjectItem', CL_UpdateObjectItem);

function CL_UpdateObject( umsg )
	local weightcur = umsg:ReadShort()
	local weightmax = umsg:ReadShort()
	local Object = umsg:ReadEntity() 
	OCRP_Object_Inventory.WeightData = {Cur = tonumber(weightcur),Max = tonumber(weightmax)} 
	OCRP_Object = Object
end
usermessage.Hook('OCRP_UpdateObject', CL_UpdateObject);

function GUI_Object_Inventory()
	GUI_Object_Inv_Frame = vgui.Create("DFrame")
	GUI_Object_Inv_Frame:SetTitle("")
	GUI_Object_Inv_Frame:SetSize(800 ,530)
	GUI_Object_Inv_Frame:Center()
	GUI_Object_Inv_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Object_Inv_Frame:GetWide()-2,GUI_Object_Inv_Frame:GetTall()-2,OCRP_Options.Color)
							end
	GUI_Object_Inv_Frame:MakePopup()
	GUI_Object_Inv_Frame:ShowCloseButton(false)
	GUI_Object_Inv_Frame.Think = function()
							if !OCRP_Object:IsValid() then
								GUI_Object_Inv_Frame:Remove()
								return
							end
						end
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Object_Inv_Frame)	
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
								GUI_Object_Inv_Frame:Remove()
							end
	local USEABLE = true 
	if OCRP_Object:IsPlayer() then
		USEABLE = false
	elseif OCRP_Object:GetNWInt("Owner") != LocalPlayer():EntIndex() then
		USEABLE = false
	end
	if OCRP_Object:GetClass() == "gov_resupply"  then
		if LocalPlayer():Team() == CLASS_POLICE || LocalPlayer():Team() == CLASS_CHIEF || LocalPlayer():Team() == CLASS_SWAT then
			USEABLE = true
		else
			USEABLE = false
		end
	end							
	GUI_Reload_Object_Inventory(GUI_Object_Inv_Frame)
	if USEABLE then
		GUI_Reload_Object_LP_Inventory(GUI_Object_Inv_Frame)
	end
	
end

function GUI_Reload_Object_Inventory(parent)
	local USEABLE = true 
	if OCRP_Object:IsPlayer() then
		USEABLE = false
	elseif OCRP_Object:GetNWInt("Owner") != LocalPlayer():EntIndex() then
		USEABLE = false
	end
	if OCRP_Object:GetClass() == "gov_resupply"  then
		if LocalPlayer():Team() == CLASS_POLICE || LocalPlayer():Team() == CLASS_CHIEF || LocalPlayer():Team() == CLASS_SWAT then
			USEABLE = true
		else
			USEABLE = false
		end
	end	
	if GUI_Object_Inv_Panel_List != nil && GUI_Object_Inv_Panel_List:IsValid() then
		GUI_Object_Inv_Panel_List:Clear()
		GUI_Weight_Object_Bevel:Remove()
	else
		GUI_Object_Inv_Panel_List = vgui.Create("DPanelList")
		GUI_Object_Inv_Panel_List:SetParent(parent)
		if USEABLE then
			GUI_Object_Inv_Panel_List:SetSize(385,480)
			GUI_Object_Inv_Panel_List:SetPos(400,20)
		else
			GUI_Object_Inv_Panel_List:SetSize(780,480)
			GUI_Object_Inv_Panel_List:SetPos(10,20)	
		end
		GUI_Object_Inv_Panel_List.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Object_Inv_Panel_List:GetWide(),GUI_Object_Inv_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
										end
		GUI_Object_Inv_Panel_List:SetPadding(7.5)
		GUI_Object_Inv_Panel_List:SetSpacing(5)
		GUI_Object_Inv_Panel_List:EnableHorizontal(3)
		GUI_Object_Inv_Panel_List:EnableVerticalScrollbar(true)

	end

	GUI_Weight_Object_Bevel = vgui.Create("DBevel")
	GUI_Weight_Object_Bevel:SetParent(GUI_Object_Inv_Frame)
	if USEABLE then
		GUI_Weight_Object_Bevel:SetSize(385,18)
		GUI_Weight_Object_Bevel:SetPos(400,505)
	else
		GUI_Weight_Object_Bevel:SetSize(780,18)
		GUI_Weight_Object_Bevel:SetPos(10,505)			
	end
	GUI_Weight_Object_Bevel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Weight_Object_Bevel:GetWide(),GUI_Weight_Object_Bevel:GetTall(),Color( 60, 60, 60, 255 ))
									if (GUI_Weight_Object_Bevel:GetWide()*(OCRP_Object_Inventory.WeightData.Cur/OCRP_Object_Inventory.WeightData.Max)) > 8 then
										draw.RoundedBox(8,1,1,(GUI_Weight_Object_Bevel:GetWide()*(OCRP_Object_Inventory.WeightData.Cur/OCRP_Object_Inventory.WeightData.Max))-1,GUI_Weight_Object_Bevel:GetTall()-1,Color( 200, 200, 200, 255 ))
									end
								end
	GUI_Weight_Object_Bevel.PaintOver = function() 
										local struc = {}
										struc.pos = {}
										struc.pos[1] = GUI_Weight_Object_Bevel:GetWide()/2 -- x pos
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
		
			local GUI_Object_Inv_Item_Panel = vgui.Create("DPanelList")
			GUI_Object_Inv_Item_Panel:SetParent(GUI_Object_Inv_Panel_List)
			GUI_Object_Inv_Item_Panel:SetSize(120,120)
			GUI_Object_Inv_Item_Panel:SetPos(0,0)
			GUI_Object_Inv_Item_Panel:SetSpacing(5)
			GUI_Object_Inv_Item_Panel.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Object_Inv_Item_Panel:GetWide(),GUI_Object_Inv_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
			local GUI_Object_Inv_Item_Icon = vgui.Create("DModelPanel")
			GUI_Object_Inv_Item_Icon:SetParent(GUI_Object_Inv_Item_Panel)
			GUI_Object_Inv_Item_Icon:SetPos(10,10)
			GUI_Object_Inv_Item_Icon:SetSize(WidthSize,WidthSize)
			
			GUI_Object_Inv_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			if GAMEMODE.OCRP_Items[item].Angle != nil then
				GUI_Object_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
			end

			if GAMEMODE.OCRP_Items[item].Material != nil then
				GUI_Object_Inv_Item_Icon:GetEntity():SetMaterial(GAMEMODE.OCRP_Items[item].Material)
			end
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			GUI_Object_Inv_Item_Icon:SetLookAt(center)
			GUI_Object_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
			local GUI_Object_Inv_Item_Name = vgui.Create("DLabel")
			GUI_Object_Inv_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Object_Inv_Item_Name:SetFont("UIBold")
			GUI_Object_Inv_Item_Name:SetText(GAMEMODE.OCRP_Items[item].Name)
			GUI_Object_Inv_Item_Name:SizeToContents()
			GUI_Object_Inv_Item_Name:SetParent(GUI_Object_Inv_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Name)
			
			GUI_Object_Inv_Item_Name:SetPos(60 - x/2,10-y/2)
			
			if amount > 1 then
				local GUI_Object_Inv_Item_Amt = vgui.Create("DLabel")
				GUI_Object_Inv_Item_Amt:SetColor(Color(255,255,255,255))
				GUI_Object_Inv_Item_Amt:SetFont("UIBold")
				GUI_Object_Inv_Item_Amt:SetText("x"..amount)
				GUI_Object_Inv_Item_Amt:SizeToContents()
				GUI_Object_Inv_Item_Amt:SetParent(GUI_Object_Inv_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("x"..amount)
				
				GUI_Object_Inv_Item_Amt:SetPos(60 - x/2,25-y/2)
			end
			if USEABLE then
				local GUI_Object_Item_Withdraw = vgui.Create("DButton")
				GUI_Object_Item_Withdraw:SetParent(GUI_Object_Inv_Item_Panel)
				GUI_Object_Item_Withdraw:SetPos(10,100)
				GUI_Object_Item_Withdraw:SetSize(100,15)
				GUI_Object_Item_Withdraw:SetText("")
				GUI_Object_Item_Withdraw.Paint = function()
												draw.RoundedBox(4,0,0,GUI_Object_Item_Withdraw:GetWide(),GUI_Object_Item_Withdraw:GetTall(),Color( 60, 60, 60, 155 ))
												draw.RoundedBox(4,1,1,GUI_Object_Item_Withdraw:GetWide()-2,GUI_Object_Item_Withdraw:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
												local struc = {}
												struc.pos = {}
												struc.pos[1] = 50 -- x pos
												struc.pos[2] = 7 -- y pos
												struc.color = Color(255,255,255,255) -- Red
												struc.text = "Withdraw" -- Text
												struc.font = "UIBold" -- Font
												struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
												struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
												draw.Text( struc )
											end
											
				GUI_Object_Item_Withdraw.DoClick = function()
												RunConsoleCommand("OCRP_WithdrawItem",item,OCRP_Object:EntIndex()) 
											end		
			end
			GUI_Object_Inv_Panel_List:AddItem(GUI_Object_Inv_Item_Panel)
			
		end
	end
	
	Inv_Icon_ent:Remove()
	
	return GUI_Object_Inv_Panel_List

end
concommand.Add("OCRP_Search",function(ply,cmd,args) if GUI_Object_Inv_Frame != nil && GUI_Object_Inv_Frame:IsValid() then return end GUI_Object_Inventory() end)

function GUI_Reload_Object_LP_Inventory(parent)
	if GUI_Object_LP_Panel_List != nil && GUI_Object_LP_Panel_List:IsValid() then
		GUI_Object_LP_Panel_List:Clear()
		GUI_Weight_LP_Bevel:Remove()
	else
		GUI_Object_LP_Panel_List = vgui.Create("DPanelList")
		GUI_Object_LP_Panel_List:SetParent(parent)
		GUI_Object_LP_Panel_List:SetSize(385,480)
		GUI_Object_LP_Panel_List:SetPos(10,20)
		GUI_Object_LP_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Object_LP_Panel_List:GetWide(),GUI_Object_LP_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
	end

		GUI_Object_LP_Panel_List:SetPadding(7.5)
		GUI_Object_LP_Panel_List:SetSpacing(2)
		GUI_Object_LP_Panel_List:EnableHorizontal(3)
		GUI_Object_LP_Panel_List:EnableVerticalScrollbar(true)
		
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
		
			local GUI_Object_LP_Item_Panel = vgui.Create("DPanelList")
			GUI_Object_LP_Item_Panel:SetParent(GUI_Object_LP_Panel_List)
			GUI_Object_LP_Item_Panel:SetSize(120,120)
			GUI_Object_LP_Item_Panel:SetPos(0,0)
			GUI_Object_LP_Item_Panel:SetSpacing(5)
			GUI_Object_LP_Item_Panel.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Object_LP_Item_Panel:GetWide(),GUI_Object_LP_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
			local GUI_Object_LP_Item_Icon = vgui.Create("DModelPanel")
			GUI_Object_LP_Item_Icon:SetParent(GUI_Object_LP_Item_Panel)
			GUI_Object_LP_Item_Icon:SetPos(10,10)
			GUI_Object_LP_Item_Icon:SetSize(WidthSize,WidthSize)
			
			GUI_Object_LP_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			if GAMEMODE.OCRP_Items[item].Angle != nil then
				GUI_Object_LP_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
			end

			if GAMEMODE.OCRP_Items[item].Material != nil then
				GUI_Object_LP_Item_Icon:GetEntity():SetMaterial(GAMEMODE.OCRP_Items[item].Material)
			end
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			GUI_Object_LP_Item_Icon:SetLookAt(center)
			GUI_Object_LP_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
			local GUI_Object_LP_Item_Name = vgui.Create("DLabel")
			GUI_Object_LP_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Object_LP_Item_Name:SetFont("UIBold")
			GUI_Object_LP_Item_Name:SetText(GAMEMODE.OCRP_Items[item].Name)
			GUI_Object_LP_Item_Name:SizeToContents()
			GUI_Object_LP_Item_Name:SetParent(GUI_Object_LP_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Name)
			
			GUI_Object_LP_Item_Name:SetPos(60 - x/2,10-y/2)
			
		--[[	local GUI_Object_LP_Item_Desc = vgui.Create("DLabel")
			GUI_Object_LP_Item_Desc:SetColor(Color(255,255,255,255))
			GUI_Object_LP_Item_Desc:SetFont("UIBold")
			GUI_Object_LP_Item_Desc:SetText(GAMEMODE.OCRP_Items[item].Desc)
			GUI_Object_LP_Item_Desc:SetWrap(true)
			GUI_Object_LP_Item_Desc:SetSize(90,40)
			GUI_Object_LP_Item_Desc:SetParent(GUI_Object_LP_Item_Panel)
			
			surface.SetFont("UIBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Desc)
			
			GUI_Object_LP_Item_Desc:SetPos(10,110)]]
			
			if amount > 1 then
				local GUI_Object_LP_Item_Amt = vgui.Create("DLabel")
				GUI_Object_LP_Item_Amt:SetColor(Color(255,255,255,255))
				GUI_Object_LP_Item_Amt:SetFont("UIBold")
				GUI_Object_LP_Item_Amt:SetText("x"..amount)
				GUI_Object_LP_Item_Amt:SizeToContents()
				GUI_Object_LP_Item_Amt:SetParent(GUI_Object_LP_Item_Panel)
				
				surface.SetFont("UIBold")
				local x,y = surface.GetTextSize("x"..amount)
				
				GUI_Object_LP_Item_Amt:SetPos(60 - x/2,25-y/2)
			end
				
			local GUI_Object_LP_Item_Deposit = vgui.Create("DButton")
			GUI_Object_LP_Item_Deposit:SetParent(GUI_Object_LP_Item_Panel)
			GUI_Object_LP_Item_Deposit:SetPos(10,100)
			GUI_Object_LP_Item_Deposit:SetSize(100,15)
			GUI_Object_LP_Item_Deposit:SetText("")
			GUI_Object_LP_Item_Deposit.Paint = function()
											draw.RoundedBox(4,0,0,GUI_Object_LP_Item_Deposit:GetWide(),GUI_Object_LP_Item_Deposit:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(4,1,1,GUI_Object_LP_Item_Deposit:GetWide()-2,GUI_Object_LP_Item_Deposit:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
											local struc = {}
											struc.pos = {}
											struc.pos[1] = 50 -- x pos
											struc.pos[2] = 7 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Deposit" -- Text
											struc.font = "UIBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
										end
										
			GUI_Object_LP_Item_Deposit.DoClick = function()
											RunConsoleCommand("OCRP_DepositItem",item,OCRP_Object:EntIndex()) 
										end
			
		GUI_Object_LP_Panel_List:AddItem(GUI_Object_LP_Item_Panel)
			
		end
	end
	
	Inv_Icon_ent:Remove()
	
	return GUI_Object_LP_Panel_List
end

function GUI_AskSearch(obj,text,requester)
	local GUI_Search_Frame = vgui.Create("DFrame")
	GUI_Search_Frame:SetTitle("")
	GUI_Search_Frame:SetSize(260 ,70)
	GUI_Search_Frame:Center()
	GUI_Search_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Search_Frame:GetWide()-2,GUI_Search_Frame:GetTall()-2,OCRP_Options.Color)
							end
	GUI_Search_Frame:MakePopup()
	GUI_Search_Frame:ShowCloseButton(false)

	local GUI_Ask  = vgui.Create("DLabel")
	GUI_Ask:SetParent(GUI_Search_Frame) 
	GUI_Ask:SetFont("UIBold")
	GUI_Ask:SetText(text)
	GUI_Ask:SetPos(5,5)
	GUI_Ask:SetColor(Color(255,255,255,255))
	GUI_Ask:SetSize(250,25)
	GUI_Ask:SetWrap(true)
	
	local GUI_Ask_Search = vgui.Create("DButton")
	GUI_Ask_Search:SetParent(GUI_Search_Frame)	
	GUI_Ask_Search:SetSize(120,20)
	GUI_Ask_Search:SetPos(5,40)
	GUI_Ask_Search:SetText("Accept request")
	GUI_Ask_Search.Paint = function() 
			draw.RoundedBox(8,0,0,GUI_Ask_Search:GetWide(),GUI_Ask_Search:GetTall(),Color( 60, 60, 60, 155 ))
			draw.RoundedBox(8,1,1,GUI_Ask_Search:GetWide()-2,GUI_Ask_Search:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))	
							end
	GUI_Ask_Search.DoClick = function()
								RunConsoleCommand("OCRP_SearchReply",obj:EntIndex(),requester:EntIndex(),"true")
								GUI_Search_Frame:Remove()
							end
	
	local GUI_Ask_Exit = vgui.Create("DButton")
	GUI_Ask_Exit:SetParent(GUI_Search_Frame)	
	GUI_Ask_Exit:SetSize(120,20)
	GUI_Ask_Exit:SetPos(130,40)
	GUI_Ask_Exit:SetText("Deny Request")
	GUI_Ask_Exit.Paint = function() 
			draw.RoundedBox(8,0,0,GUI_Ask_Exit:GetWide(),GUI_Ask_Exit:GetTall(),Color( 60, 60, 60, 155 ))
			draw.RoundedBox(8,1,1,GUI_Ask_Exit:GetWide()-2,GUI_Ask_Exit:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
			end
	GUI_Ask_Exit.DoClick = function()
								RunConsoleCommand("OCRP_SearchReply",obj:EntIndex(),requester:EntIndex(),"false")
								GUI_Search_Frame:Remove()
							end
end

function CL_AskSearch( umsg )
	local text = umsg:ReadString()
	local obj = umsg:ReadEntity()
	local requester = umsg:ReadEntity()
	GUI_AskSearch(obj,text,requester)
end
usermessage.Hook('OCRP_AskSearch', CL_AskSearch);

local vgui = vgui
local draw = draw
local surface = surface
local OC_Alert = Material("gui/OCRP/OCRP_Alert")

function GUI_MainMenu()
	if LocalPlayer():GetNWBool("Handcuffed") || !LocalPlayer():Alive() then return end
	if GUI_Trade_Frame then if GUI_Trade_Frame:IsValid() then return false end end
	GUI_Main_Frame = vgui.Create("DFrame")
	GUI_Main_Frame:SetTitle("")
	GUI_Main_Frame:SetSize(768 ,525)
	GUI_Main_Frame:Center()
	GUI_Main_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Main_Frame:GetWide()-2,GUI_Main_Frame:GetTall()-2,OCRP_Options.Color)
							end
	GUI_Main_Frame:MakePopup()
	GUI_Main_Frame:ShowCloseButton(false)
	
	local GUI_Property_Sheet = vgui.Create("DPropertySheet")
	GUI_Property_Sheet:SetParent(GUI_Main_Frame)
	GUI_Property_Sheet:SetPos(12,10)
	GUI_Property_Sheet:SetSize(744,525 )
	GUI_Property_Sheet.Paint = function() 

								end
								
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Property_Sheet)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(724,0)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()
								GUI_Main_Frame:Remove()
							end
	
	GUI_Inv_tab_Panel = vgui.Create("DPanel")
	GUI_Inv_tab_Panel:SetParent(GUI_Property_Sheet)
	GUI_Inv_tab_Panel:SetSize(746,480)
	GUI_Inv_tab_Panel:SetPos(11,22)
	GUI_Inv_tab_Panel.Paint = function()
								end
	
	GUI_Skill_tab_Panel = vgui.Create("DPanel")
	GUI_Skill_tab_Panel:SetParent(GUI_Property_Sheet)
	GUI_Skill_tab_Panel:SetSize(746,480)
	GUI_Skill_tab_Panel:SetPos(11,22)
	GUI_Skill_tab_Panel.Paint = function()
								end
								
	GUI_Org_tab_Panel = vgui.Create("DPanel")
	GUI_Org_tab_Panel:SetParent(GUI_Property_Sheet)
	GUI_Org_tab_Panel:SetSize(746,480)
	GUI_Org_tab_Panel:SetPos(11,22)
	GUI_Org_tab_Panel.Paint = function()
								end

	GUI_Bud_tab_Panel = vgui.Create("DPanel")
	GUI_Bud_tab_Panel:SetParent(GUI_Property_Sheet)
	GUI_Bud_tab_Panel:SetSize(746,480)
	GUI_Bud_tab_Panel:SetPos(11,22)
	GUI_Bud_tab_Panel.Paint = function()
								end
	GUI_Options_tab_Panel = vgui.Create("DPanel")
	GUI_Options_tab_Panel:SetParent(GUI_Property_Sheet)
	GUI_Options_tab_Panel:SetSize(746,480)
	GUI_Options_tab_Panel:SetPos(11,22)
	GUI_Options_tab_Panel.Paint = function()
								end								

	GUI_Help_tab_Panel = vgui.Create("DPanel")
	GUI_Help_tab_Panel:SetParent(GUI_Property_Sheet)
	GUI_Help_tab_Panel:SetSize(746,480)
	GUI_Help_tab_Panel:SetPos(11,22)
	GUI_Help_tab_Panel.Paint = function()
								end
									
	GUI_ChatLogging_tab_Panel = vgui.Create("DPanel")
	GUI_ChatLogging_tab_Panel:SetParent(GUI_Property_Sheet)
	GUI_ChatLogging_tab_Panel:SetSize(746,480)
	GUI_ChatLogging_tab_Panel:SetPos(11,22)
	GUI_ChatLogging_tab_Panel.Paint = function()
								end
								
	-- GUI_AdminLogging_tab_Panel = vgui.Create("DPanel")
	-- GUI_AdminLogging_tab_Panel:SetParent(GUI_Property_Sheet)
	-- GUI_AdminLogging_tab_Panel:SetSize(746,480)
	-- GUI_AdminLogging_tab_Panel:SetPos(11,22)
	-- GUI_AdminLogging_tab_Panel.Paint = function()
								-- end	
														
	GUI_Property_Sheet:AddSheet( "Inventory", GUI_Inv_tab_Panel, "gui/silkicons/user", true, true, "Manage the items in your inventory" )
	GUI_Property_Sheet:AddSheet( "Skills", GUI_Skill_tab_Panel, "gui/silkicons/star", true, true, "Select/Manage your skills" )
	GUI_Property_Sheet:AddSheet( "Organisation", GUI_Org_tab_Panel, "gui/silkicons/group", true, true, "View your organisation's info." )
	GUI_Property_Sheet:AddSheet( "Buddys", GUI_Bud_tab_Panel, "gui/silkicons/group", true, true, "View, add and remove buddys." )
	GUI_Property_Sheet:AddSheet( "Options", GUI_Options_tab_Panel, "gui/silkicons/world", true, true, "Adjust options here." )
	GUI_Property_Sheet:AddSheet( "Help/Rules/Definitions", GUI_Help_tab_Panel, "gui/silkicons/exclamation", true, true, "Everything you need" )
	GUI_Property_Sheet:AddSheet( "Chat Logging", GUI_ChatLogging_tab_Panel, "gui/silkicons/exclamation", true, true, "Logs Everything In Chat" )	
	-- if LocalPlayer():IsAdmin() then
		-- GUI_Property_Sheet:AddSheet( "Admin Logging", GUI_AdminLogging_tab_Panel, "gui/silkicons/exclamation", true, true, "Admin Event Logging" )	
	-- end
		
	GUI_Rebuild_Inventory(GUI_Inv_tab_Panel)
	GUI_Rebuild_Skills(GUI_Skill_tab_Panel)
	GUI_Rebuild_Orgs(GUI_Org_tab_Panel)
	GUI_Rebuild_Buds(GUI_Bud_tab_Panel)
	GUI_Rebuild_Options(GUI_Options_tab_Panel)
	GUI_Rebuild_Help(GUI_Help_tab_Panel)
	GUI_Rebuild_ChatLogging(GUI_ChatLogging_tab_Panel)
	-- if LocalPlayer():IsAdmin() then
		-- GUI_Rebuild_AdminLogging(GUI_AdminLogging_tab_Panel)
	-- end
	
	for _,panel in pairs(GUI_Property_Sheet.Items) do
		panel.Tab:SetAutoStretchVertical(false)
		panel.Tab:SetSize(50,50)
		panel.Tab.Paint = function() 
							draw.RoundedBox(8,0,0,panel.Tab:GetWide()-4,panel.Tab:GetTall()+10,Color( 60, 60, 60, 155 ))
						end
	end
end

function GM:OnSpawnMenuOpen()
	if LocalPlayer():InVehicle() then
		if LocalPlayer():GetVehicle():GetModel() == "models/sickness/lcpddr.mdl" then
			RunConsoleCommand("OCRP_toggle_s");
			return;
		elseif LocalPlayer():GetVehicle():GetModel() == "models/tdmcars/copcar.mdl" then
			RunConsoleCommand("OCRP_toggle_s");
			return;
		elseif LocalPlayer():GetVehicle():GetModel() == "models/sickness/meatwagon.mdl" then
			RunConsoleCommand("OCRP_toggle_s");
			return; 
		elseif LocalPlayer():GetVehicle():GetModel() == "models/sickness/truckfire.mdl" then
			RunConsoleCommand("OCRP_toggle_s");
			return; 
		elseif LocalPlayer():GetVehicle():GetModel() == "models/sickness/stockade2dr.mdl" then
			RunConsoleCommand("OCRP_toggle_s");
			return; 
		elseif LocalPlayer():GetVehicle():GetModel() == "models/sickness/murcielag1.mdl" then
			RunConsoleCommand("OCRP_toggle_s");
			return; 	
		end
			
	end
	if GUI_Main_Frame != nil && GUI_Main_Frame:IsValid() then
		GUI_Main_Frame:Remove()
	else
		GUI_MainMenu()	
	end
end

function GM:OnSpawnMenuClose()
	-- if GUI_Main_Frame != nil && GUI_Main_Frame:IsValid() then
		-- GUI_Main_Frame:Remove()
	-- end
end

function GUI_Rebuild_Help(parent)

	local GUI_Panel_List = vgui.Create("DPanel")
	GUI_Panel_List:SetParent(parent)
	GUI_Panel_List:SetSize(746,480)
	GUI_Panel_List:SetPos(0,0)
	GUI_Panel_List.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Panel_List:GetWide(),GUI_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
							end
	--[[local GUI_HTML_HELP = vgui.Create("HTML")
	GUI_HTML_HELP:SetParent(GUI_Panel_List)
	GUI_HTML_HELP:SetPos(0,0)
	GUI_HTML_HELP:SetSize(746, 480)
	GUI_HTML_HELP:OpenURL("http://orangecosmos.co.uk/index.php?topic=1574.0")]]
						
	local GUI_Help = vgui.Create("DButton")
	GUI_Help:SetParent(GUI_Panel_List)
	GUI_Help:SetPos(23,10)
	GUI_Help:SetSize(700,150)
	GUI_Help:SetText("")
	GUI_Help.Paint = function()
					draw.RoundedBox(4,0,0,GUI_Help:GetWide(),GUI_Help:GetTall(),Color( 60, 60, 60, 155 ))
					draw.RoundedBox(4,1,1,GUI_Help:GetWide()-2,GUI_Help:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
					
					local struc = {}
					struc.pos = {}
					struc.pos[1] = GUI_Help:GetWide()/2 -- x pos
					struc.pos[2] = GUI_Help:GetTall()/2 -- y pos
					struc.color = Color(255,255,255,255) -- Red
					struc.font = "UIBold" -- Font
					struc.text = "Click to view the roleplay definitions" -- Text
					struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
					struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
					draw.Text( struc )
				end
	GUI_Help.DoClick = function()								
		local GUI_Frame = vgui.Create("DFrame")
		GUI_Frame:SetTitle("")
		GUI_Frame:SetSize(ScrW() ,ScrH())
		GUI_Frame:Center()
		GUI_Frame.Paint = function()
									draw.RoundedBox(8,1,1,GUI_Frame:GetWide()-2,GUI_Frame:GetTall()-2,OCRP_Options.Color)
								end
		GUI_Frame:MakePopup()	
		
		local GUI_HTML_HELP = vgui.Create("HTML")
		GUI_HTML_HELP:SetParent(GUI_Frame)
		GUI_HTML_HELP:SetPos(0,25)
		GUI_HTML_HELP:SetSize(ScrW(), ScrH()-50)
		GUI_HTML_HELP:OpenURL("http://www.catalyst-gaming.net/index.php?topic=982.0")
	end

	local GUI_Def = vgui.Create("DButton")
	GUI_Def:SetParent(GUI_Panel_List)
	GUI_Def:SetPos(23,170)
	GUI_Def:SetSize(700,140)
	GUI_Def:SetText("")
	GUI_Def.Paint = function()
					draw.RoundedBox(4,0,0,GUI_Def:GetWide(),GUI_Def:GetTall(),Color( 60, 60, 60, 155 ))
					draw.RoundedBox(4,1,1,GUI_Def:GetWide()-2,GUI_Def:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
					
					local struc = {}
					struc.pos = {}
					struc.pos[1] = GUI_Def:GetWide()/2 -- x pos
					struc.pos[2] = GUI_Def:GetTall()/2 -- y pos
					struc.color = Color(255,255,255,255) -- Red
					struc.font = "UIBold" -- Font
					struc.text = "Click to view server rules" -- Text
					struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
					struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
					draw.Text( struc )
				end
	GUI_Def.DoClick = function()								
		local GUI_Frame = vgui.Create("DFrame")
		GUI_Frame:SetTitle("")
		GUI_Frame:SetSize(ScrW() ,ScrH())
		GUI_Frame:Center()
		GUI_Frame.Paint = function()
									draw.RoundedBox(8,1,1,GUI_Frame:GetWide()-2,GUI_Frame:GetTall()-2,OCRP_Options.Color)
								end
		GUI_Frame:MakePopup()	
		
		local GUI_HTML_HELP = vgui.Create("HTML")
		GUI_HTML_HELP:SetParent(GUI_Frame)
		GUI_HTML_HELP:SetPos(0,25)
		GUI_HTML_HELP:SetSize(ScrW(), ScrH()-50)
		GUI_HTML_HELP:OpenURL("http://www.catalyst-gaming.net/index.php?topic=981.0")
	end
	
	local GUI_Site = vgui.Create("DButton")
	GUI_Site:SetParent(GUI_Panel_List)
	GUI_Site:SetPos(23,320)
	GUI_Site:SetSize(700,150)
	GUI_Site:SetText("")
	GUI_Site.Paint = function()
					draw.RoundedBox(4,0,0,GUI_Site:GetWide(),GUI_Site:GetTall(),Color( 60, 60, 60, 155 ))
					draw.RoundedBox(4,1,1,GUI_Site:GetWide()-2,GUI_Site:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
					
					local struc = {}
					struc.pos = {}
					struc.pos[1] = GUI_Site:GetWide()/2 -- x pos
					struc.pos[2] = GUI_Site:GetTall()/2 -- y pos
					struc.color = Color(255,255,255,255) -- Red
					struc.font = "UIBold" -- Font
					struc.text = "Click to view the Catalyst Gaming website" -- Text
					struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
					struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
					draw.Text( struc )
				end
	GUI_Site.DoClick = function()								
		local GUI_Frame = vgui.Create("DFrame")
		GUI_Frame:SetTitle("")
		GUI_Frame:SetSize(ScrW() ,ScrH())
		GUI_Frame:Center()
		GUI_Frame.Paint = function()
									draw.RoundedBox(8,1,1,GUI_Frame:GetWide()-2,GUI_Frame:GetTall()-2,OCRP_Options.Color)
								end
		GUI_Frame:MakePopup()	
		
		local GUI_HTML_HELP = vgui.Create("HTML")
		GUI_HTML_HELP:SetParent(GUI_Frame)
		GUI_HTML_HELP:SetPos(0,25)
		GUI_HTML_HELP:SetSize(ScrW(), ScrH()-50)
		GUI_HTML_HELP:OpenURL("http://www.catalyst-gaming.net/index.php?action=forum")
	end	
end

CreateClientConVar("ocrp_advlights", "1", true, false)
function GUI_Rebuild_Options(parent)
		local GUI_Options_Panel_List = vgui.Create("DPanel")
		GUI_Options_Panel_List:SetParent(parent)
		GUI_Options_Panel_List:SetSize(746,480)
		GUI_Options_Panel_List:SetPos(0,0)
		GUI_Options_Panel_List.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Options_Panel_List:GetWide(),GUI_Options_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
	
	local GUI_Options_Color_Label = vgui.Create("DLabel")
	GUI_Options_Color_Label:SetText("Change your menu colors here!")
	GUI_Options_Color_Label:SetFont("HUDNumber3")
	GUI_Options_Color_Label:SetParent(GUI_Options_Panel_List)
	GUI_Options_Color_Label:SetPos(5,10)
	GUI_Options_Color_Label:SizeToContents()
	
	local GUI_Options_Color = vgui.Create("DMultiChoice")
	GUI_Options_Color:SetParent(GUI_Options_Panel_List)
	GUI_Options_Color:SetPos(5,100)
	GUI_Options_Color:SetSize(240,20)
	GUI_Options_Color:AddChoice("Red")
	GUI_Options_Color:AddChoice("Gray")
	GUI_Options_Color:AddChoice("Green")
	GUI_Options_Color:AddChoice("Black")
	GUI_Options_Color:AddChoice("White")
	GUI_Options_Color:AddChoice("Blue")
	GUI_Options_Color:AddChoice("Orange")
	function GUI_Options_Color:OnSelect(index,value,data)
		if value == "Red" then
			OCRP_Options.Color = Color(200,30,30,155)
		elseif value == "Gray" then 
			OCRP_Options.Color = Color(110,110,110,155)
		elseif value == "Green" then 
			OCRP_Options.Color = Color(30,200,30,155)
		elseif value == "Black" then 
			OCRP_Options.Color = Color(30,30,30,155)
		elseif value == "White" then 
			OCRP_Options.Color = Color(200,200,200,155)
		elseif value == "Blue" then 
			OCRP_Options.Color = Color(30,30,200,155)
		elseif value == "Orange" then 
			OCRP_Options.Color = Color(210,120,30,155)
		end
		GUI_Main_Frame:Remove()
		GUI_MainMenu()
	end
	local GUI_Options_advlights = vgui.Create( "DCheckBoxLabel" )
	GUI_Options_advlights:SetParent(GUI_Options_Panel_List)
	GUI_Options_advlights:SetPos( 5,370 )
	GUI_Options_advlights:SetText( "Use Advanced Emergency Vehicle Lights" )
	GUI_Options_advlights:SetConVar( "ocrp_advlights" )
	GUI_Options_advlights:SizeToContents()

	return GUI_Options_Panel_List
end

local ChatLoggingTable = {}
function AddToChatLogTable( line )
	if line == "" then return end
	ChatLoggingTable[line] = os.date( "%H:%M:%S" )
end
function GUI_Rebuild_ChatLogging(parent)
		local GUI_ChatLogging_Panel_List = vgui.Create("DListView")
		GUI_ChatLogging_Panel_List:SetParent(parent)
		GUI_ChatLogging_Panel_List:SetSize(746,480)
		GUI_ChatLogging_Panel_List:SetPos(0,0)
		GUI_ChatLogging_Panel_List:SetMultiSelect(false)
		GUI_ChatLogging_Panel_List:AddColumn("Time"):SetFixedWidth( 60 )
		GUI_ChatLogging_Panel_List:AddColumn("Chat Text")
		
		for line, curtime in pairs(ChatLoggingTable) do
			GUI_ChatLogging_Panel_List:AddLine( curtime, line )
		end
		GUI_ChatLogging_Panel_List:SortByColumn( 1, true )
		
	return GUI_ChatLogging_Panel_List
end

local AdminLoggingTable = {}
function AddToAdminLogTable( line )
	if line == "" then return end
	ChatLoggingTable[line] = os.date( "%H:%M:%S" )
	--AdminLoggingTable[line] = os.date( "%H:%M:%S" )
end
function GUI_Rebuild_AdminLogging(parent)
		local GUI_AdminLogging_Panel_List = vgui.Create("DListView")
		GUI_AdminLogging_Panel_List:SetParent(parent)
		GUI_AdminLogging_Panel_List:SetSize(746,480)
		GUI_AdminLogging_Panel_List:SetPos(0,0)
		GUI_AdminLogging_Panel_List:SetMultiSelect(false)
		GUI_AdminLogging_Panel_List:AddColumn("Time"):SetFixedWidth( 60 )
		GUI_AdminLogging_Panel_List:AddColumn("Event")
		
		for line, curtime in pairs(AdminLoggingTable) do
			GUI_AdminLogging_Panel_List:AddLine( curtime, line )
		end
		GUI_AdminLogging_Panel_List:SortByColumn( 1, true )
		
	return GUI_AdminLogging_Panel_List
end

function GUI_BankMenu()
	local GUI_Bank_Frame = vgui.Create("DFrame")
	GUI_Bank_Frame:SetTitle("")
	GUI_Bank_Frame:SetSize(250 ,80)
	GUI_Bank_Frame:Center()
	GUI_Bank_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Bank_Frame:GetWide(),GUI_Bank_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Bank_Frame:GetWide()-2,GUI_Bank_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UIBold")
								local x,y = surface.GetTextSize("Bank menu")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Bank menu")
							end
	GUI_Bank_Frame:MakePopup()
	GUI_Bank_Frame:ShowCloseButton(false)
	
	local GUI_Bank_Exit = vgui.Create("DButton")
	GUI_Bank_Exit:SetParent(GUI_Bank_Frame)	
	GUI_Bank_Exit:SetSize(20,20)
	GUI_Bank_Exit:SetPos(228,2)
	GUI_Bank_Exit:SetText("")
	GUI_Bank_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Bank_Exit:GetWide(),GUI_Bank_Exit:GetTall())
									end
	GUI_Bank_Exit.DoClick = function()
								GUI_Bank_Frame:Remove()
							end

	local GUI_Bank_Balance = vgui.Create("DLabel")
	GUI_Bank_Balance:SetFont("UIBold")
	GUI_Bank_Balance:SetParent(GUI_Bank_Frame)
	GUI_Bank_Balance:SetPos(10,15)
	GUI_Bank_Balance:SetTextColor(Color(255,255,255,255))
	GUI_Bank_Balance:SetText("Current Balance : $"..tonumber(LocalPlayer().Bank))
	GUI_Bank_Balance:SizeToContents()
	
	local GUI_Bank_Entry = vgui.Create("DTextEntry")
	GUI_Bank_Entry:SetFont("UIBold")
	GUI_Bank_Entry:SetValue(0)
	GUI_Bank_Entry:SetSize(150,15)
	GUI_Bank_Entry:SetEditable(true)
	GUI_Bank_Entry:SetUpdateOnType(true)
	GUI_Bank_Entry:SetNumeric(true)
	GUI_Bank_Entry:SetParent(GUI_Bank_Frame)
	GUI_Bank_Entry:SetPos(42 ,30)	
	
	GUI_Bank_Entry.OnEnter = function()
								local price = math.Round(tonumber(GUI_Bank_Entry:GetValue()))
								if price <= 0 then
									GUI_Bank_Entry:SetValue(0)
								end
							end
	
	local GUI_Bank_Withdraw = vgui.Create("DButton")
	GUI_Bank_Withdraw:SetParent(GUI_Bank_Frame)	
	GUI_Bank_Withdraw:SetSize(120,20)
	GUI_Bank_Withdraw:SetPos(5,50)
	GUI_Bank_Withdraw:SetText("Withdraw")
	GUI_Bank_Withdraw.DoClick = function()
								local price = math.Round(tonumber(GUI_Bank_Entry:GetValue()))
								if price <= 0 then
									GUI_Bank_Entry:SetValue(0)
								end	
								if tonumber(GUI_Bank_Entry:GetValue()) > tonumber(LocalPlayer().Bank) then
									GUI_Bank_Frame:Remove()
									return
								end
								RunConsoleCommand("OCRP_Withdraw_Money",tonumber(GUI_Bank_Entry:GetValue()))
								GUI_Bank_Frame:Remove()
							end
	GUI_Bank_Withdraw.Paint = function()						
			draw.RoundedBox(8,0,0,GUI_Bank_Withdraw:GetWide(),GUI_Bank_Withdraw:GetTall(),Color( 60, 60, 60, 155 ))
			draw.RoundedBox(8,1,1,GUI_Bank_Withdraw:GetWide()-2,GUI_Bank_Withdraw:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))		
		end
		
	local GUI_Bank_Deposit = vgui.Create("DButton")
	GUI_Bank_Deposit:SetParent(GUI_Bank_Frame)	
	GUI_Bank_Deposit:SetSize(120,20)
	GUI_Bank_Deposit:SetPos(125,50)
	GUI_Bank_Deposit:SetText("Deposit")
	GUI_Bank_Deposit.DoClick = function()
								local price = math.Round(tonumber(GUI_Bank_Entry:GetValue()))
								if price <= 0 then
									GUI_Bank_Entry:SetValue(0)
								end		
								if tonumber(GUI_Bank_Entry:GetValue()) > tonumber(LocalPlayer().Wallet) then
									GUI_Bank_Frame:Remove()
									return
								end
								RunConsoleCommand("OCRP_Deposit_Money",tonumber(GUI_Bank_Entry:GetValue()))
								GUI_Bank_Frame:Remove()
							end
	GUI_Bank_Deposit.Paint = function()						
			draw.RoundedBox(8,0,0,GUI_Bank_Deposit:GetWide(),GUI_Bank_Deposit:GetTall(),Color( 60, 60, 60, 155 ))
			draw.RoundedBox(8,1,1,GUI_Bank_Deposit:GetWide()-2,GUI_Bank_Deposit:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))		

		end
							
end

concommand.Add("OCRP_Bank",function(ply,cmd,args) for _,obj in pairs(ents.FindByClass("Bank_atm")) do  if obj:GetPos():Distance(LocalPlayer():GetPos()) < 100 then GUI_BankMenu() end end end)

TYPING = false
	
RunConsoleCommand("gm_clearfonts" )
surface.CreateFont ("UiBold",ScreenScale(7), 700, true, false, "UiGood")


function ChatBoxInit()
	GUI_ChatBox_Panel = vgui.Create("DPanelList")
	GUI_ChatBox_Panel:SetSize(ScrW(),ScrH()/6)
	GUI_ChatBox_Panel:SetPos(20,ScrH()/1.6)
	GUI_ChatBox_Panel:EnableVerticalScrollbar(true)
	GUI_ChatBox_Panel.Paint = function() end
	GUI_ChatBox_Panel.VBar.Think = function()			
										if !TYPING then
											GUI_ChatBox_Panel.VBar:SetSize(1,1)
											GUI_ChatBox_Panel.VBar:SetPos(GUI_ChatBox_Panel:GetWide() + 300,GUI_ChatBox_Panel:GetTall() + 300)	 
										end
									end
end

GM.Chat = {}
GM.Chat["ooc"] = {Text = "(OOC) :",ChatColor = Color(255,255,255,255)}
GM.Chat["looc"] = {Text = "(LOOC) :",ChatColor = Color( 190, 190, 190, 255 )}
GM.Chat["yell"] = {Text = " :",ChatColor = Color(255, 165, 0, 255 )}
GM.Chat["local"] = {Text = " :",ChatColor = Color(255,243,169) }
GM.Chat["me"] = {Text = "",ChatColor = Color( 210, 30, 30, 255 ),NameColor = Color( 210, 30, 30, 255 ) }
GM.Chat["whisper"] = {Text = " :",ChatColor = Color(215, 255, 222, 255 )}
GM.Chat["help"] = {Text = "",ChatText = "screams for help!",ChatColor = Color( 255, 30, 30, 255 ),NameColor = Color( 220, 30, 30, 255 )}
GM.Chat["emergancy"] = {Text = "(911) :",ChatColor = Color( 255, 30, 30, 255 ),NameColor = Color(255, 30, 30,255)}
GM.Chat["broadcast"] = {Text = "(Broadcast)",ChatColor = Color( 255, 30, 30, 255 ),NameColor = Color(255, 30, 30,255)}
GM.Chat["radio"] = {Text = "(Radio) :",ChatColor = Color(90,204,255,255)}
GM.Chat["advert"] = {Text = "(Advert) :",ChatColor = Color(255,255,255,255),NameColor = Color(255,255,255,255)}
GM.Chat["pm"] = {Text = "(PM) :",ChatColor = Color( 0, 220, 20, 255 )}
GM.Chat["ocrp"] = {Text = ":",ChatColor = Color(255,255,255,255),NameColor = Color(255,255,255,255)}
GM.Chat["msg"] = {Text = "", ChatColor = Color(25,220,45,255), NameColor = Color(25,220,45,255)}
GM.Chat["org"] = {Text = ":",ChatColor = Color(0,255,255,255)}
GM.Chat["admin"] = {Text = "(Admin) :", ChatColor = Color(69,185,255,255), NameColor = Color(69,185,255,255)}
GM.Chat["superadmin"] = {Text = "(SuperAdmin) :", ChatColor = Color(69,185,240,255), NameColor = Color(69,185,240,255)}

function StartChat(TeamSay)
	RunConsoleCommand("OCRP_IsTyping")

	TYPING = true
		if GUI_ChatBox_Cmd != nil && GUI_ChatBox_Cmd:IsValid() then
			GUI_ChatBox_Cmd:Remove()
		end
		GUI_ChatBox_Cmd = vgui.Create("DButton")
		GUI_ChatBox_Cmd:SetSize(80,25)
		GUI_ChatBox_Cmd:SetPos(20,ScrH()/1.26)
		GUI_ChatBox_Cmd:SetText("")
		GUI_ChatBox_Cmd.Text = "Say"
		GUI_ChatBox_Cmd.Paint = function()
									if !TYPING then return end
									surface.SetFont("UiGood")
									local x,y = 0,0
									if GUI_ChatBox_Entry_Label.Text != nil then
										x,y = surface.GetTextSize(GUI_ChatBox_Cmd.Text)
									end
									draw.RoundedBox(4,0,0,GUI_ChatBox_Cmd:GetWide(),GUI_ChatBox_Cmd:GetTall(),Color(0,0,0,50))
									draw.RoundedBox(4,1,1,GUI_ChatBox_Cmd:GetWide()-2,GUI_ChatBox_Cmd:GetTall()-2,OCRP_Options.Color)		
									draw.SimpleText(GUI_ChatBox_Cmd.Text,"UiGood",GUI_ChatBox_Cmd:GetWide()/2-x/2,GUI_ChatBox_Cmd:GetTall()/2 - y/2,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
								end
		
		if GUI_ChatBox_Entry_Label != nil && GUI_ChatBox_Entry_Label:IsValid() then
			GUI_ChatBox_Entry_Label:Remove()
		end
		
		GUI_ChatBox_Entry_Label = vgui.Create("DBevel")
		GUI_ChatBox_Entry_Label:SetPos(100,ScrH()/1.26)
		GUI_ChatBox_Entry_Label:SetSize(500,25)
		GUI_ChatBox_Entry_Label.Text = ""
		GUI_ChatBox_Entry_Label.Paint = function() 
											surface.SetFont("UiGood") 
											local x,y = 0,0
											if GUI_ChatBox_Entry_Label.Text != nil then
												x,y = surface.GetTextSize(GUI_ChatBox_Entry_Label.Text)
											end
											GUI_ChatBox_Entry_Label:SetWide(x + 10)
											if tostring(GUI_ChatBox_Entry_Label.Text) != "" then
				draw.SimpleTextOutlined(GUI_ChatBox_Entry_Label.Text,"UiGood",2,5,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,1,Color(0,0,0,255) )					
											end
										end
	return true
end
hook.Add("StartChat", "OpenMyChatBox", StartChat)

function GM:ChatTextChanged( text ) 
	GUI_ChatBox_Entry_Label.Text = text
	local exploded = string.Explode(" ",GUI_ChatBox_Entry_Label.Text)
	if string.find(exploded[1],"///") then 
		GUI_ChatBox_Cmd.Text = "Local OOC"		
	elseif string.find(exploded[1],"//") && !string.find(exploded[1],"///") then 
		GUI_ChatBox_Cmd.Text = "OOC"	
	elseif string.find(exploded[1],"/") && !string.find(exploded[1],"//") && !string.find(exploded[1],"///") then 
		GUI_ChatBox_Cmd.Text = "Command"
		if string.find(exploded[1],"/me") then 
			GUI_ChatBox_Cmd.Text = "Me"
		elseif string.find(exploded[1],"/broad") || string.find(exploded[1],"/broadcast") || string.find(exploded[1],"/br") then 
			GUI_ChatBox_Cmd.Text = "Broadcast"
		elseif string.find(exploded[1],"/help") then
			GUI_ChatBox_Cmd.Text = "HELP"
		elseif string.find(exploded[1],"/911") then
			GUI_ChatBox_Cmd.Text = "911"
		elseif string.find(exploded[1],"/711") then
			GUI_ChatBox_Cmd.Text = "711"	
		elseif string.find(exploded[1],"/999") then
			GUI_ChatBox_Cmd.Text = "999"
		elseif string.find(exploded[1],"/advert") then
			GUI_ChatBox_Cmd.Text = "Advert"
		elseif string.find(exploded[1],"/411") then
			GUI_ChatBox_Cmd.Text = "411"		
		elseif string.find(exploded[1],"/radio") then
			GUI_ChatBox_Cmd.Text = "Gov. Radio"			
		elseif string.find(exploded[1],"/pm") then
			GUI_ChatBox_Cmd.Text = "PM"
		elseif string.find(exploded[1],"/a") then
			GUI_ChatBox_Cmd.Text = "Admin"
		elseif string.find(exploded[1],"/sa") then
			GUI_ChatBox_Cmd.Text = "SuperAdmin"
		elseif string.find(exploded[1],"/org") then
			GUI_ChatBox_Cmd.Text = "Org Chat"
		elseif string.find(exploded[1],"/y") || string.find(exploded[1],"/yell") then
			GUI_ChatBox_Cmd.Text = "Yell"	
		elseif string.find(exploded[1],"/w") || string.find(exploded[1],"/whisper") then
			GUI_ChatBox_Cmd.Text = "Whisper"					
		end
	else
		GUI_ChatBox_Cmd.Text = "Say"
	end		
end

function ChatAdd(text,speaker,chattype,speakerobj)
		if table.Count(GUI_ChatBox_Panel:GetItems()) > 100 then
			RunConsoleCommand("OCRP_ClearChat")
		end
		if text == "" then return end
		local GUI_ChatBox_Speak_Panel = vgui.Create("DPanel")
		GUI_ChatBox_Speak_Panel:SetSize(ScrW(),25)
		GUI_ChatBox_Speak_Panel:SetPos(5,20)
		GUI_ChatBox_Speak_Panel.Paint = function()
								end	
		GUI_ChatBox_Speak_Panel.EndTime = CurTime() + 15								
	
		local GUI_ChatBox_Name = vgui.Create("DBevel")
		GUI_ChatBox_Name:SetParent(GUI_ChatBox_Speak_Panel)
		GUI_ChatBox_Name.Color = Color(255,255,255,255)
		
		if GAMEMODE.Chat[string.lower(chattype)] != nil then
			GUI_ChatBox_Name.Text = (speaker..GAMEMODE.Chat[string.lower(chattype)].Text)
			if GAMEMODE.Chat[string.lower(chattype)].NameColor != nil then
				GUI_ChatBox_Name.Color = GAMEMODE.Chat[string.lower(chattype)].NameColor
			else
				GUI_ChatBox_Name.Color = team.GetColor(speakerobj:Team())
			end
		else
			GUI_ChatBox_Name.Text = (speaker)
		end
	
	GUI_ChatBox_Name:SetFont("UiGood")
		
		surface.SetFont("UiGood")
		local x,y = surface.GetTextSize(GUI_ChatBox_Name.Text)
			
		GUI_ChatBox_Name:SetSize(x + 10,25)
		GUI_ChatBox_Name:SetPos(5,0)	
		
		GUI_ChatBox_Name.Paint = function()
										draw.SimpleTextOutlined(GUI_ChatBox_Name.Text,"UiGood",5,1,GUI_ChatBox_Name.Color,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,1,Color(0,0,0,GUI_ChatBox_Name.Color.a))
									end	
									
		local GUI_ChatBox_Chat = vgui.Create("DBevel")
		GUI_ChatBox_Chat:SetParent(GUI_ChatBox_Speak_Panel)
		GUI_ChatBox_Chat.Text = (text)

		if GAMEMODE.Chat[string.lower(chattype)] != nil then
			GUI_ChatBox_Chat.Color = GAMEMODE.Chat[string.lower(chattype)].ChatColor
			if GAMEMODE.Chat[string.lower(chattype)].ChatText != nil then
				GUI_ChatBox_Chat.Text = (GAMEMODE.Chat[string.lower(chattype)].ChatText)
			end
		else
			GUI_ChatBox_Chat.Color = Color(255,255,255,255)
		end
		
		surface.SetFont("UiGood")
		local x,y = surface.GetTextSize(GUI_ChatBox_Chat.Text)
		
		GUI_ChatBox_Chat:SetSize(x + 10,25)	
		GUI_ChatBox_Chat:SetPos(GUI_ChatBox_Name:GetWide() + 10 ,0)		
		GUI_ChatBox_Chat.Paint = function()
										draw.SimpleTextOutlined(GUI_ChatBox_Chat.Text,"UiGood",1,1,GUI_ChatBox_Chat.Color,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,1,Color(0,0,0,GUI_ChatBox_Chat.Color.a))
									end		
		GUI_ChatBox_Panel:AddItem(GUI_ChatBox_Speak_Panel)

	GUI_ChatBox_Speak_Panel.Alpha = 255
	
	GUI_ChatBox_Speak_Panel.Think = function()
										--[[if (CurTime() - GUI_ChatBox_Speak_Panel.EndTime) > 300 then 
											GUI_ChatBox_Panel:RemoveItem(GUI_ChatBox_Speak_Panel)
										end]]
										if CurTime() >= GUI_ChatBox_Speak_Panel.EndTime  then
											if !TYPING then
												if GUI_ChatBox_Speak_Panel.Alpha <= 0 then
													GUI_ChatBox_Speak_Panel.Alpha = 0
												else
													GUI_ChatBox_Speak_Panel.Alpha = GUI_ChatBox_Speak_Panel.Alpha - 1
												end
											else
												if GUI_ChatBox_Speak_Panel.Alpha >= 255 then
													GUI_ChatBox_Speak_Panel.Alpha = 255
												else
													GUI_ChatBox_Speak_Panel.Alpha = GUI_ChatBox_Speak_Panel.Alpha + 2
												end
												
											end
										GUI_ChatBox_Name.Color = Color(GUI_ChatBox_Name.Color.r,GUI_ChatBox_Name.Color.g,GUI_ChatBox_Name.Color.b,GUI_ChatBox_Speak_Panel.Alpha)
										GUI_ChatBox_Chat.Color = Color(GUI_ChatBox_Chat.Color.r,GUI_ChatBox_Chat.Color.g,GUI_ChatBox_Chat.Color.b,GUI_ChatBox_Speak_Panel.Alpha)			
										end			
									end	
	GUI_ChatBox_Speak_Panel.Name = GUI_ChatBox_Name
	GUI_ChatBox_Speak_Panel.Chat = GUI_ChatBox_Chat
	timer.Simple(0.01,function() 
		if GUI_ChatBox_Panel.VBar != nil && GUI_ChatBox_Panel.VBar:IsValid() then 
			GUI_ChatBox_Panel.VBar:SetScroll(GUI_ChatBox_Panel:GetCanvas():GetTall()) 
		end
	end)
end



function FinishChat(TeamSay)
	RunConsoleCommand("OCRP_EndTyping")
	GUI_ChatBox_Cmd:Remove()
	GUI_ChatBox_Entry_Label:Remove()
	TYPING = false
end
hook.Add("FinishChat", "HideMyChatBox", FinishChat)

function CL_Typing( umsg )
	local obj = umsg:ReadEntity()
	local bool = umsg:ReadBool() 
	obj.Typing = bool
end
usermessage.Hook('OCRP_IsTyping', CL_Typing);

function GM:OnPlayerChat(plySpeaker, strText, boolTeamOnly, boolPlayerIsDead)
	if boolTeamOnly then
		PrintToAdmin(plySpeaker,"OOC",strText)
		chat.AddText(Color( 255, 255, 255, 255 ),plySpeaker,"(OOC): "..strText)
		ChatAdd(strText,plySpeaker:Nick(),"ooc",plySpeaker)
		AddToChatLogTable(plySpeaker:Nick().."(OOC): "..strText)
		return
	end
	local tbl = string.ToTable(strText)
	local exploded = string.Explode(" ",strText)
	if tbl[1] == "@" and plySpeaker:GetLevel() <= 3 then
		strText = string.gsub(exploded[1], "@", "")
		PrintToAdmin(plySpeaker,"Admin",strText)
		chat.AddText(Color( 190, 190, 190, 255 ), plySpeaker,"(Admin): "..strText)
		ChatAdd(strText,plySpeaker:Nick(),"admin",plySpeaker)
		return 
	end
	if !boolPlayerIsDead then 
		surface.SetFont("CloseCaption_Normal")
		if tbl[1] == "/" then
			if string.find(exploded[1],"///") then
				strText = string.gsub(strText, "///", "")
				PrintToAdmin(plySpeaker,"LOCAL OOC",strText)
				chat.AddText(Color( 190, 190, 190, 255 ), plySpeaker,"(LOOC): "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"looc",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(LOOC): "..strText)
			elseif string.find(exploded[1],"/account") and plySpeaker == LocalPlayer() then
				CLChangePass()
			elseif string.find(exploded[1],"//") and !string.find(exploded[1],"///") and !string.find(exploded[1],"/y ") and !string.find(exploded[1], "/w ") and !string.find(exploded[1],"/pm") then 
				strText = string.gsub(strText,"//","")
				PrintToAdmin(plySpeaker,"OOC",strText)
				chat.AddText(Color( 255, 255, 255, 255 ),plySpeaker,"(OOC): "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"ooc",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(OOC): "..strText)
			elseif string.find(exploded[1],"/me") then 
				strText = string.gsub(strText,"/me","")
				PrintToAdmin(plySpeaker,"ME",strText)
				chat.AddText(Color( 210, 30, 30, 255 ),plySpeaker:Nick()..strText)
				ChatAdd(strText,plySpeaker:Nick(),"me",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(ME): "..strText)
			elseif string.find(exploded[1],"/help") then 
				strText = " screams for help!"
				PrintToAdmin(plySpeaker,"HELP",strText)
				chat.AddText(Color( 220, 30, 30, 255 ),plySpeaker:Nick()..strText)
				ChatAdd(strText,plySpeaker:Nick(),"help",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(HELP): "..strText)
			elseif string.find(exploded[1],"/advert") then
				if !CL_HasItem("item_cell")&& plySpeaker == LocalPlayer()  then OCRP_AddHint("You need a cell phone for this") return end
				strText = string.gsub(strText, "/advert", "")
				PrintToAdmin(plySpeaker,"ADVERT",strText)
				chat.AddText(Color( 255, 255, 255, 255 ), "(Advert): "..strText)
				ChatAdd(strText,"","advert",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(ADVERT): "..strText)
			elseif string.find(exploded[1],"/pm") then
				if !CL_HasItem("item_cell") && plySpeaker == LocalPlayer() then OCRP_AddHint("You need a cell phone for this") return end
				strText = string.gsub(strText, "/pm", "")
				PrintToAdmin(plySpeaker,"PM",strText)
				chat.AddText(Color( 0, 220, 20, 255 ),plySpeaker,"(PM): "..strText)	
				ChatAdd(strText,plySpeaker:Nick(),"pm",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(PM): "..strText)
			elseif string.find(exploded[1],"/org") then
				if !CL_HasItem("item_cell") && plySpeaker == LocalPlayer() then OCRP_AddHint("You need a cell phone for this") return end
				strText = string.gsub(strText, "/org", "")
				PrintToAdmin(plySpeaker,"org",strText)
				chat.AddText(Color( 0, 225, 255, 255 ), plySpeaker,"(ORG): "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"org",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(ORG): "..strText)
			elseif string.find(exploded[1],"/911") then
				if !CL_HasItem("item_cell") && plySpeaker == LocalPlayer() then OCRP_AddHint("You need a cell phone for this") return end
				strText = string.gsub(strText,"/911","")
				PrintToAdmin(plySpeaker,"911",strText)
				chat.AddText(Color( 255, 10, 10, 255 ),plySpeaker,"(911): "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"emergancy",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(911): "..strText)
			elseif string.find(exploded[1],"/999") then
				if !CL_HasItem("item_cell") && plySpeaker == LocalPlayer() then OCRP_AddHint("You need a cell phone for this") return end
				strText = string.gsub(strText,"/999","")
				PrintToAdmin(plySpeaker,"999",strText)
				chat.AddText(Color( 255, 10, 10, 255 ),plySpeaker,"(911): "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"emergancy",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(999): "..strText)
			elseif string.find(exploded[1],"/radio") then 
				if !CL_HasItem("item_policeradio") && plySpeaker == LocalPlayer() then OCRP_AddHint("You need a police radio for this") return end
				if plySpeaker:Team() != CLASS_CITIZEN then
					strText = string.gsub(strText,"/radio","")
					chat.AddText(Color(90, 204, 255, 255 ),plySpeaker,"(Radio): "..strText)
					ChatAdd(strText,plySpeaker:Nick(),"radio",plySpeaker)
					AddToChatLogTable(plySpeaker:Nick().."(RADIO): "..strText)
				end
				PrintToAdmin(plySpeaker,"RADIO",strText)
			elseif string.find(exploded[1],"/y") then
				strText = string.gsub(strText,"/y","")
				PrintToAdmin(plySpeaker,"YELL",strText)
				chat.AddText(Color(255, 165, 0, 255 ),plySpeaker,": "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"yell",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(YELL): "..strText)
			elseif string.find(exploded[1],"/w") then
				strText = string.gsub(strText,"/w","")
				PrintToAdmin(plySpeaker,"WHISPER",strText)
				chat.AddText(Color(215, 255, 222, 255 ),plySpeaker,": "..strText)	
				ChatAdd(strText,plySpeaker:Nick(),"whisper",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(WHISPER): "..strText)
			elseif string.find(exploded[1],"/711") then 
				if !CL_HasItem("item_cell") && plySpeaker == LocalPlayer() then OCRP_AddHint("You need a cell phone for this") return end
				strText = string.gsub(strText,"/711","")
				PrintToAdmin(plySpeaker,"711",strText)
				chat.AddText(Color( 255, 10, 10, 255 ),plySpeaker,"(911): "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"emergancy",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(711): "..strText)
			elseif string.find(exploded[1],"/411") then 
				if !CL_HasItem("item_cell") && plySpeaker == LocalPlayer() then OCRP_AddHint("You need a cell phone for this") return end
				strText = string.gsub(strText,"/411","")
				PrintToAdmin(plySpeaker,"411",strText)
				chat.AddText(Color( 255, 10, 10, 255 ),plySpeaker,"(911): "..strText)
				ChatAdd(strText,plySpeaker:Nick(),"emergancy",plySpeaker)
				AddToChatLogTable(plySpeaker:Nick().."(411): "..strText)
			elseif string.find(exploded[1],"/broadcast") then 
				if plySpeaker:Team() == CLASS_Mayor then
					strText = string.gsub(strText,"/broadcast","")
					chat.AddText(Color( 230, 0, 0, 255 ),"(Broadcast):"..strText)
					RunConsoleCommand("OCRP_Broadcast",strText,30)
					ChatAdd(strText,"","broadcast",plySpeaker)
					AddToChatLogTable(plySpeaker:Nick().."(BROADCAST): "..strText)
				end
			elseif string.find(exploded[1],"/sa") then
				strText = string.gsub(strText,"/sa","")
				//PrintToAdmin(plySpeaker,"ADMIN",strText)
				ChatAdd(strText,plySpeaker:Nick(),"superadmin",plySpeaker)	
			elseif string.find(exploded[1],"/a") then
				strText = string.gsub(strText,"/a","")
				PrintToAdmin(plySpeaker,"ADMIN",strText)
				ChatAdd(strText,plySpeaker:Nick(),"admin",plySpeaker)	
			end
		else
			chat.AddText(Color(255,243,169), plySpeaker,": "..strText)
			PrintToAdmin(plySpeaker,"LOCAL",strText)
			ChatAdd(strText,plySpeaker:Nick(),"local",plySpeaker)
			AddToChatLogTable(plySpeaker:Nick().."(LOCAL): "..strText)
		end
	else
		if string.find(exploded[1],"/a") then
			strText = string.gsub(strText,"/a","")
			PrintToAdmin(plySpeaker,"ADMIN",strText)
			ChatAdd(strText,plySpeaker:Nick(),"admin",plySpeaker)	
			return
		end
		chat.AddText(Color(255,255,255), plySpeaker," (OOC): "..strText)
		PrintToAdmin(plySpeaker,"OOC",strText)
		ChatAdd(strText,plySpeaker:Nick(),"ooc",plySpeaker)
		AddToChatLogTable(plySpeaker:Nick().."(OOC): "..strText)
	end
	return true

end

concommand.Add("OCRP_ClearChat",function(ply,cmd,args) 
	GUI_ChatBox_Panel:Remove()
	
	GUI_ChatBox_Panel = vgui.Create("DPanelList")
	GUI_ChatBox_Panel:SetSize(ScrW(),ScrH()/6)
	GUI_ChatBox_Panel:SetPos(20,ScrH()/1.6)
	GUI_ChatBox_Panel:EnableVerticalScrollbar(true)
	GUI_ChatBox_Panel.Paint = function() end
	GUI_ChatBox_Panel.VBar.Think = function()			
										if !TYPING then
											GUI_ChatBox_Panel.VBar:SetSize(1,1)
											GUI_ChatBox_Panel.VBar:SetPos(GUI_ChatBox_Panel:GetWide() + 300,GUI_ChatBox_Panel:GetTall() + 300)	 
										end
									end
end)

function JoinLeaveA( playerindex, playername, text, messagetype )
	if messagetype == "joinleave" then
		ChatAdd(text,"","msg",playername)
	end
	if messagetype == "none" then
		if string.find(text, "killed") then
			if string.find(text, "using") then
				return false
			end
		end
	end
end
hook.Add( "ChatText", "JoinLeaveHook", JoinLeaveA );

function PrintToAdmin( Speaker, ChatType, Message, bool )
	if ChatType == "RESPAWN_NPCS" then
		if LocalPlayer():IsAdmin() then
			ChatAdd(Message,"OCRP","admin",LocalPlayer())
		end
		return false
	end
	if ChatType == "-USED" then
		if LocalPlayer():IsSuperAdmin() then
			ChatAdd(Message,"OCRP","superadmin",LocalPlayer())
			return false
		end
		return false
	end
	if ChatType == "-SPAWN" then
		if LocalPlayer():IsSuperAdmin() then
			ChatAdd(Message,"OCRP","superadmin",LocalPlayer())
			return false
		end
		return false
	end
	local SpeakerName
	if bool then SpeakerName = Speaker else SpeakerName = Speaker:Nick() end
	if LocalPlayer():IsAdmin() then
		LocalPlayer():PrintMessage( HUD_PRINTCONSOLE, "[".. ChatType .."] -> [".. SpeakerName .."] -> ".. Message .."\n" )
		AddToAdminLogTable("[".. ChatType .."] -> [".. SpeakerName .."] -> ".. Message)
	end
end

function CLPrintToAdminUM( um )
	PrintToAdmin( um:ReadString(), um:ReadString(), um:ReadString(), true )
end
usermessage.Hook( "ocrp_printadmin", CLPrintToAdminUM )

local KeyPressLooking=false
local AdminFunctionRequired=""
local PlayerInNeed=nil
local Chat_AdminNotifyConvar = CreateClientConVar("Chat_AdminNotify", "1", true, false)

function Chat_AdminHelp(plySpeaker, strText)
if Chat_AdminNotifyConvar:GetInt()==0 then return end
	if LocalPlayer():IsAdmin() then
		local LowersrtText=string.lower(strText)
		if (string.find(LowersrtText, "admin") or string.find(LowersrtText, "adminz") or string.find(LowersrtText, "admins")) then
			timer.Destroy("resettimer")
			if SinglePlayer() then
				Msg("[Auto Admin]"..plySpeaker:Nick().." Needs Help. Press F2 To Teleport")
			else
				ChatAdd(plySpeaker:Nick().." needs help. Press F2 to teleport.", "OCRP", "admin", LocalPlayer())
			end
			KeyPressLooking=true
			AdminFunctionRequired="teleport"
			PlayerInNeed=plySpeaker:Nick()
			timer.Create( "resettimer", 5, 1, function()
				KeyPressLooking=false
				PlayerInNeed=nil
			end )
		elseif string.find(LowersrtText, "stuck") then
			timer.Destroy("resettimer")
			if SinglePlayer() then
				Msg("[Auto Admin]"..plySpeaker:Nick().." Needs Help. Press F2 To Teleport")
			else
				ChatAdd(plySpeaker:Nick().." needs help. Press F2 to teleport.", "OCRP", "admin", LocalPlayer())
			end
			KeyPressLooking=true
			AdminFunctionRequired="teleport"
			PlayerInNeed=plySpeaker:Nick()
			timer.Create( "resettimer", 5, 1, function()
				KeyPressLooking=false
				PlayerInNeed=nil
			end )
		elseif string.find(LowersrtText, "respawn") then
			timer.Destroy("resettimer")
			if SinglePlayer() then
				Msg("[Auto Admin]"..plySpeaker:Nick().." Needs Help. Press F2 To Respawn")
			else
				ChatAdd(plySpeaker:Nick().." needs Help. Press F2 to respawn.", "OCRP", "admin", LocalPlayer())
			end
			KeyPressLooking=true
			AdminFunctionRequired="respawn"
			PlayerInNeed=plySpeaker:Nick()
			timer.Create( "resettimer", 5, 1, function()
				KeyPressLooking=false
				PlayerInNeed=nil
			end )
		end
	end
end
hook.Add("OnPlayerChat", "Chat_AdminHelp", Chat_AdminHelp)

function KeyThink()
if Chat_AdminNotifyConvar:GetInt()==0 then return end
	if( input.IsKeyDown(93)) then
		if KeyPressLooking==true then
				if AdminFunctionRequired=="teleport" then
					RunConsoleCommand("ASS_TeleportTo", PlayerInNeed )
				elseif AdminFunctionRequired=="respawn" then
					RunConsoleCommand("ASS_RevivePlayer", PlayerInNeed )
				end
			KeyPressLooking=false
			PlayerInNeed=nil
		end
	end
end
hook.Add( "Think", "KeyThink", KeyThink )

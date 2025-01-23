local vgui = vgui
local draw = draw
local surface = surface
local usermessage = usermessage

function GM.GetOrgSetup( um )
	local id = um:ReadLong()
	GAMEMODE.Orgs[id] = GAMEMODE.Orgs[id] or {}
	GAMEMODE.Orgs[id].Name = um:ReadString()
	GAMEMODE.Orgs[id].Owner = um:ReadString()
	GAMEMODE.Orgs[id].Notes = um:ReadString()
	GAMEMODE.Orgs[id].Members = {}
	
	LocalPlayer().Org = id
end
usermessage.Hook('ocrp_org_setup', GM.GetOrgSetup)

function SecondIDCL( um )
	local OrgIDCL = um:ReadLong()
	LocalPlayer().Org = OrgIDCL
end
usermessage.Hook("ocrp_second_id", SecondIDCL)

function SecondIDCLL( um )
	local OrgIDCL = 0
	LocalPlayer().Org = 0
end
usermessage.Hook("ocrp_second_id_l", SecondIDCLL)

function GM.OrgUpdateAMem( um )
	local Name = um:ReadString()
	local memid = um:ReadString()
	for k, v in pairs(GAMEMODE.Orgs[LocalPlayer():GetOrg()].Members) do
		if v.steamid == memid then
			table.remove(GAMEMODE.Orgs[LocalPlayer():GetOrg()].Members, k)
			return
		end
	end
	table.insert(GAMEMODE.Orgs[LocalPlayer():GetOrg()].Members, {name = Name, steamid = memid})
end
usermessage.Hook('ocrp_org_members_update', GM.OrgUpdateAMem)

function GM.OrgSetupMems( um )
	local aid = um:ReadLong()
	local aName = um:ReadString()
	local memID = um:ReadString()
	LocalPlayer().Org = aid
	table.insert(GAMEMODE.Orgs[aid].Members, {name = aName, steamid = memID})
	
	
	PrintTable(GAMEMODE.Orgs[aid])
end
usermessage.Hook('ocrp_org_members_setup', GM.OrgSetupMems)

function GM.OrgUpdateName( um )
	GAMEMODE.Orgs[LocalPlayer():GetOrg()].Name = um:ReadString()
end
usermessage.Hook('ocrp_org_update_name', GM.OrgUpdateName)

function GM.OrgUpdateNotes( um )
	GAMEMODE.Orgs[LocalPlayer():GetOrg()].Notes = um:ReadString()
end
usermessage.Hook('ocrp_org_update_notes', GM.OrgUpdateNotes)

function GM.GetInvite( um )
	OrgInvite(um:ReadString())
end
usermessage.Hook('ocrp_inv_mem', GM.GetInvite)

function ClientPrintTab()
	PrintTable(GAMEMODE.Orgs[LocalPlayer():GetOrg()])
end
concommand.Add("OCRP_TestClientTables", ClientPrintTab)

function PMETA:GetOrg()
	if self.Org == nil then
		return 0
	elseif self.Org == 0 then
		return 0
	elseif self.Org > 0 then
		return self.Org
	end
end

function GUI_Rebuild_Orgs(parent)
	if GUI_Orgs_Panel_List != nil && GUI_Orgs_Panel_List:IsValid() then
		GUI_Orgs_Panel_List:Clear()
	else
		GUI_Orgs_Panel_List = vgui.Create("DPanelList")
		GUI_Orgs_Panel_List:SetParent(parent)
		GUI_Orgs_Panel_List:SetSize(746,480)
		GUI_Orgs_Panel_List:SetPos(0,0)
		GUI_Orgs_Panel_List.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Orgs_Panel_List:GetWide(),GUI_Orgs_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_Orgs_Panel_List:SetPadding(7.5)
		GUI_Orgs_Panel_List:SetSpacing(5)
		GUI_Orgs_Panel_List:EnableHorizontal(3)
		GUI_Orgs_Panel_List:EnableVerticalScrollbar(true)
	end
	
	if (LocalPlayer().Org == 0 or LocalPlayer().Org == nil) then
		local ZehLabel = vgui.Create("DLabel", GUI_Orgs_Panel_List )
		ZehLabel:SetPos( GUI_Orgs_Panel_List:GetWide() / 2 - 220, GUI_Orgs_Panel_List:GetTall() / 2 - 40 )
		ZehLabel:SetText("You are not in a organisation.")
		ZehLabel:SetFont("HUDNumber3")
		ZehLabel:SetColor( Color(255,255,255,255) )
		ZehLabel:SizeToContents()
		return GUI_Orgs_Panel_List
		
	elseif GAMEMODE.Orgs[LocalPlayer().Org].Owner == LocalPlayer():SteamID() then
		
		local MembersTitle = vgui.Create("DLabel", GUI_Orgs_Panel_List )
		MembersTitle:SetPos( 10, 5 )
		MembersTitle:SetText( "Members:" )
		MembersTitle:SetFont( "Trebuchet19" )
		MembersTitle:SetColor( Color(255,255,255,255) )
		MembersTitle:SizeToContents()
		
		local TextEntryName = vgui.Create("DTextEntry", GUI_Orgs_Panel_List )
		TextEntryName:SetTall( 20 )
		TextEntryName:SetWide( 353 )
		TextEntryName:SetText(	GAMEMODE.Orgs[LocalPlayer().Org].Name )
		TextEntryName:SetPos( 383, 15 )
		TextEntryName.OnEnter = function() RunConsoleCommand( "ocrp_uon", TextEntryName:GetValue() ) end
		
		local ComboBox1 = vgui.Create("DListView", GUI_Orgs_Panel_List )
		ComboBox1:SetTall( 208 )
		ComboBox1:SetWide( 364 )
		ComboBox1:SetPos( 10, 26 )
		ComboBox1:AddColumn("Status"):SetFixedWidth( 60 )
		ComboBox1:AddColumn("Name")
		ComboBox1:AddColumn("SteamID"):SetFixedWidth( 100 )
		
		for _, Data in pairs(GAMEMODE.Orgs[LocalPlayer().Org].Members) do
			local online = false
			local owner = false
			for k, ply in pairs(player.GetAll()) do
				if ply:SteamID() == GAMEMODE.Orgs[LocalPlayer().Org].Owner then
					if ply:SteamID() == Data.steamid then
						online = true
						owner = true
						break
					else
						owner = true
						break
					end
				elseif ply:SteamID() == Data.steamid then
					online = true
					break
				end
			end
			if online && owner then
				ComboBox1:AddLine("[O]Online", Data.name, Data.steamid)
			elseif owner then
				ComboBox1:AddLine("[O]Offline", Data.name, Data.steamid)
			elseif online then
				ComboBox1:AddLine("Online", Data.name, Data.steamid)
			else
				ComboBox1:AddLine("Offline", Data.name, Data.steamid)
			end
		end
		ComboBox1:SortByColumn( 1, true )
		
		local PotMembersTitle = vgui.Create("DLabel", GUI_Orgs_Panel_List )
		PotMembersTitle:SetPos( 10, 237 )
		PotMembersTitle:SetText( "Potential Members:" )
		PotMembersTitle:SetFont( "Trebuchet19" )
		PotMembersTitle:SetColor( Color(255,255,255,255) )
		PotMembersTitle:SizeToContents()
		
		local ComboBox2 = vgui.Create("DListView", GUI_Orgs_Panel_List )
		ComboBox2:SetTall( 213 )
		ComboBox2:SetWide( 364 )
		ComboBox2:SetPos( 10, 259 )
		ComboBox2:AddColumn("Name")
		ComboBox2:AddColumn("SteamID")
		
		for k, v in pairs(player.GetAll()) do
			if v.Org != LocalPlayer().Org then
				ComboBox2:AddLine(v:Nick(), v:SteamID())
			end
		end
		
		local NotesBox = vgui.Create("DTextEntry", GUI_Orgs_Panel_List )
		NotesBox:SetTall( 194 )
		NotesBox:SetWide( 353 )
		NotesBox:SetPos( 383, 40 )
		NotesBox:SetMultiline( true )
		NotesBox:SetText( GAMEMODE.Orgs[LocalPlayer().Org].Notes )
		
		local NoteButton = vgui.Create("DButton", GUI_Orgs_Panel_List )
		NoteButton:SetTall( 21 )
		NoteButton:SetWide( 353 )
		NoteButton:SetPos( 383, 236 )
		NoteButton:SetText( " " )
		NoteButton.Paint = function()
								draw.RoundedBox(8,0,0,NoteButton:GetWide(),NoteButton:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,NoteButton:GetWide()-2,NoteButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
								local struc = {}
								struc.pos = {}
								struc.pos[1] = 176.5 -- x pos
								struc.pos[2] = 10.5 -- y pos
								struc.color = Color(255,255,255,255) -- Red
								struc.text = "Update Notes" -- Text
								struc.font = "UIBold" -- Font
								struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
								struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
								draw.Text( struc )
							end
		NoteButton.DoClick = function() RunConsoleCommand("ocrp_uono", NotesBox:GetValue()) end
		
		
		local KickPlayer = vgui.Create("DButton", GUI_Orgs_Panel_List)
		KickPlayer:SetPos( 383, 345 )
		KickPlayer:SetTall( 30 )
		KickPlayer:SetWide( 353 )
		KickPlayer:SetText( " " )
		KickPlayer.Paint = function()
								draw.RoundedBox(8,0,0,KickPlayer:GetWide(),KickPlayer:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,KickPlayer:GetWide()-2,KickPlayer:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
								local struc = {}
								struc.pos = {}
								struc.pos[1] = 176.5 -- x pos
								struc.pos[2] = 15 -- y pos
								struc.color = Color(255,255,255,255) -- Red
								struc.text = "Kick Selected Member" -- Text
								struc.font = "UIBold" -- Font
								struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
								struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
								draw.Text( struc )
							end
		
		KickPlayer.DoClick = function(KickPlayer)
										for k, v in pairs(player.GetAll()) do
											if v != LocalPlayer() then
												if v:SteamID() == ComboBox1:GetSelected()[1]:GetValue(3) then
													ToKick = v:SteamID()
													RunConsoleCommand("ocrp_orem", ToKick)
												end
											end
										end
									end
		
		local InvitePlayer = vgui.Create("DButton", GUI_Orgs_Panel_List)
		InvitePlayer:SetPos( 383, 380 )
		InvitePlayer:SetTall( 30 )
		InvitePlayer:SetWide( 353 )
		InvitePlayer:SetText( " " )
		InvitePlayer.Paint = function()
								draw.RoundedBox(8,0,0,InvitePlayer:GetWide(),InvitePlayer:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,InvitePlayer:GetWide()-2,InvitePlayer:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
								local struc = {}
								struc.pos = {}
								struc.pos[1] = 176.5 -- x pos
								struc.pos[2] = 15 -- y pos
								struc.color = Color(255,255,255,255) -- Red
								struc.text = "Invite Selected Player" -- Text
								struc.font = "UIBold" -- Font
								struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
								struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
								draw.Text( struc )
							end
		InvitePlayer.DoClick = function(InvitePlayer) RunConsoleCommand("ocrp_oinv", ComboBox2:GetSelected()[1]:GetValue(2)) end
		
		return GUI_Orgs_Panel_List
	else
		local NamLabel = vgui.Create( "DLabel", GUI_Orgs_Panel_List)
		NamLabel:SetPos( 383, 15 )
		NamLabel:SetText( "Name: ".. LocalPlayer():GetNWString("OrgName") )
		NamLabel:SetFont( "Trebuchet19" )
		NamLabel:SetColor( Color(255,255,255,255) )
		NamLabel:SizeToContents()
		
		local MembersTitle = vgui.Create("DLabel", GUI_Orgs_Panel_List )
		MembersTitle:SetPos( 10, 5 )
		MembersTitle:SetText( "Members:" )
		MembersTitle:SetFont( "Trebuchet19" )
		MembersTitle:SetColor( Color(255,255,255,255) )
		MembersTitle:SizeToContents()
		
		local ComboBox1 = vgui.Create("DListView", GUI_Orgs_Panel_List )
		ComboBox1:SetTall( 208 )
		ComboBox1:SetWide( 364 )
		ComboBox1:SetPos( 10, 26 )
		ComboBox1:AddColumn("Status"):SetFixedWidth( 60 )
		ComboBox1:AddColumn("Name")
		
		for _, Data in pairs(GAMEMODE.Orgs[LocalPlayer().Org].Members) do
			local online = false
			local owner = false
			for k, ply in pairs(player.GetAll()) do
				if ply:SteamID() == GAMEMODE.Orgs[LocalPlayer().Org].Owner then
					online = true
					owner = true
					break
				elseif Data.steamid == GAMEMODE.Orgs[LocalPlayer().Org].Owner then
					owner = true
					break
				elseif ply:SteamID() == Data.steamid then
					online = true
					break
				end
			end
			if online && owner then
				ComboBox1:AddLine("[O]Online", Data.name)
			elseif owner then
				ComboBox1:AddLine("[O]Offline", Data.name)
			elseif online then
				ComboBox1:AddLine("Online", Data.name)
			else
				ComboBox1:AddLine("Offline", Data.name)
			end
		end
		ComboBox1:SortByColumn( 1, true )
		
		local NotesBox = vgui.Create("DTextEntry", GUI_Orgs_Panel_List )
		NotesBox:SetTall( 194 )
		NotesBox:SetWide( 353 )
		NotesBox:SetPos( 383, 40 )
		NotesBox:SetMultiline( true )
		NotesBox:SetEditable( false )
		NotesBox:SetText( "Organisation Notes: " .. GAMEMODE.Orgs[LocalPlayer().Org].Notes )
	end
end

function OrgInvite( Name )
	local invfx = ScrW() / 2 - 100
	local invfy = ScrH() / 2 - 100
	local OINVFrame = vgui.Create( "DFrame" )
	OINVFrame:SetWide( 200 )
	OINVFrame:SetTall( 150 )
	OINVFrame:SetPos( invfx, invfy )
	OINVFrame:SetTitle( "Organization Invite: ".. Name )
	OINVFrame.Paint = function()
							draw.RoundedBox(8,1,1,OINVFrame:GetWide()-2,OINVFrame:GetTall()-2,OCRP_Options.Color)
						end
	OINVFrame:MakePopup()
	OINVFrame:ShowCloseButton( false )
	
	local OINVLab = vgui.Create( "DLabel", OINVFrame )
	OINVLab:SetPos( 5, 20 )
	OINVLab:SetTall( 50 )
	OINVLab:SetWide( 190 )
	OINVLab:SetColor( Color( 255, 255, 255, 255 ) )
	OINVLab:SetText( "You have been invited to join ".. Name ..".\n Please accept or deny below." )
	OINVLab:SetWrap( true )
	
	local OINVButton_A = vgui.Create( "DButton", OINVFrame )
	OINVButton_A:SetPos( 5, 70 )
	OINVButton_A:SetTall( 20 )
	OINVButton_A:SetWide( 190 )
	OINVButton_A:SetText( " " )
	OINVButton_A.Paint = function()
									draw.RoundedBox(8,0,0,OINVButton_A:GetWide(),OINVButton_A:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(8,1,1,OINVButton_A:GetWide()-2,OINVButton_A:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 95 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Accept" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	OINVButton_A.DoClick = function(OINVButton_A) RunConsoleCommand("ocrp_oinva") OINVFrame:Close() end
	
	local OINVButton_D = vgui.Create( "DButton", OINVFrame )
	OINVButton_D:SetPos( 5, 105 )
	OINVButton_D:SetTall( 20 )
	OINVButton_D:SetWide( 190 )
	OINVButton_D:SetText( " " )
	OINVButton_D.Paint = function()
									draw.RoundedBox(8,0,0,OINVButton_D:GetWide(),OINVButton_D:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(8,1,1,OINVButton_D:GetWide()-2,OINVButton_D:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 95 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Deny" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	OINVButton_D.DoClick = function(OINVButton_D) RunConsoleCommand("ocrp_oinvd") OINVFrame:Close() end
end
concommand.Add("OrgInvite", OrgInvite)
	
		
	
	

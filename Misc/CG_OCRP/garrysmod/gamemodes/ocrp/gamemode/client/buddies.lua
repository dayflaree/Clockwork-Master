OCRP_Buddies = {}

function GM.GetBuddies( um )
	local bud = um:ReadEntity()
	for k,v in pairs(OCRP_Buddies) do
		if v == bud then
			table.remove(OCRP_Buddies, k)
			return
		end
	end
	table.insert(OCRP_Buddies, bud)
end
usermessage.Hook( 'ocrp_buds', GM.GetBuddies)

function GUI_Rebuild_Buds(parent)
	if GUI_Buds_Panel_List != nil && GUI_Buds_Panel_List:IsValid() then
		GUI_Buds_Panel_List:Clear()
	else
		GUI_Buds_Panel_List = vgui.Create("DPanelList")
		GUI_Buds_Panel_List:SetParent(parent)
		GUI_Buds_Panel_List:SetSize(746,480)
		GUI_Buds_Panel_List:SetPos(0,0)
		GUI_Buds_Panel_List.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Buds_Panel_List:GetWide(),GUI_Buds_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_Buds_Panel_List:SetPadding(7.5)
		GUI_Buds_Panel_List:SetSpacing(5)
		GUI_Buds_Panel_List:EnableHorizontal(3)
		GUI_Buds_Panel_List:EnableVerticalScrollbar(true)
	end
	
	local ListBox = vgui.Create("DListView", parent)
	ListBox:SetTall( 420 )
	ListBox:SetWide( 726 )
	ListBox:SetPos( 10, 20 )
	
	ListBox:AddColumn( "Name" )
	ListBox:AddColumn( "Friend" )
	ListBox:AddColumn( "UniqueID" )
	
	for k, v in pairs(player.GetAll()) do
		if v != LocalPlayer() then
			Friend = "No"
			for k, bud in pairs(OCRP_Buddies) do
				if v == bud then
					Friend = "Yes"
				end
			end
			ListBox:AddLine( v:Nick(), Friend, v:UniqueID() )
		end
	end
			
	local AddBuddyButton = vgui.Create("DButton", parent)
	AddBuddyButton:SetPos( 45, 445)
	AddBuddyButton:SetText( " " )
	AddBuddyButton:SetTall( 20 )
	AddBuddyButton:SetWide( 331.5 )
	AddBuddyButton.Paint = function()
								draw.RoundedBox(8,0,0,AddBuddyButton:GetWide(),AddBuddyButton:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,AddBuddyButton:GetWide()-2,AddBuddyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
								local struc = {}
								struc.pos = {}
								struc.pos[1] = 165.75 -- x pos
								struc.pos[2] = 10 -- y pos
								struc.color = Color(255,255,255,255) -- Red
								struc.text = "Add Buddy" -- Text
								struc.font = "UIBold" -- Font
								struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
								struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
								draw.Text( struc )
							end
	AddBuddyButton.DoClick = function(AddBuddyButton) RunConsoleCommand("OCRP_AddBuddy", tostring(ListBox:GetSelected()[1]:GetValue(3))) ListBox:GetSelected()[1]:SetValue(2, "Yes" ) end				
	
	local RemoveBuddyButton = vgui.Create("DButton", parent)
	RemoveBuddyButton:SetPos( 378, 445)
	RemoveBuddyButton:SetText( " " )
	RemoveBuddyButton:SetTall( 20 )
	RemoveBuddyButton:SetWide( 331.5 )
	RemoveBuddyButton.Paint = function()
								draw.RoundedBox(8,0,0,RemoveBuddyButton:GetWide(),RemoveBuddyButton:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,RemoveBuddyButton:GetWide()-2,RemoveBuddyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
								local struc = {}
								struc.pos = {}
								struc.pos[1] = 165.75 -- x pos
								struc.pos[2] = 10 -- y pos
								struc.color = Color(255,255,255,255) -- Red
								struc.text = "Remove Buddy" -- Text
								struc.font = "UIBold" -- Font
								struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
								struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
								draw.Text( struc )
							end
	RemoveBuddyButton.DoClick = function(RemoveBuddyButton) RunConsoleCommand("OCRP_RemoveBuddy", tostring(ListBox:GetSelected()[1]:GetValue(3))) ListBox:GetSelected()[1]:SetValue(2, "No" )	end
	
	return GUI_Buds_Panel_List
end

function GetSpecCL( um )
	SpecEnt = um:ReadEntity()
	LocalPlayer().Spec = tostring(um:ReadBool())
end
usermessage.Hook("Spec", GetSpecCL)

function GetSpecEndCL( um )
	SpecEnt = nil
	LocalPlayer().Spec = nil
end
usermessage.Hook("SpecEnd", GetSpecEndCL)

LocalPlayer().Energy = 100
LocalPlayer().ChargeInt = 0

function CL_GetChargeInt()
	if LocalPlayer().ChargeInt == nil then
		LocalPlayer().ChargeInt = 0
	end
	return LocalPlayer().ChargeInt or 0
end

function CL_GetEnergy()
	return LocalPlayer().Energy or 100
end

function CL_SetEnergy( ZeAmt )
	LocalPlayer().Energy = ZeAmt
end

function UM_GetForceWalkCL( umsg )
	LocalPlayer().ForceWalk = umsg:ReadBool()
end
usermessage.Hook("inhib_forcewalk", UM_GetForceWalkCL)

function GetForceWalk()
	return LocalPlayer().ForceWalk or false
end

function CL_ResetEnergy( umsg )
	LocalPlayer().Energy = umsg:ReadLong()
end
usermessage.Hook("spawning_energy", CL_ResetEnergy)

function CL_GetSodaCL( umsg )
	CL_SetEnergy( umsg:ReadLong() )
end
usermessage.Hook("soda_energy", CL_GetSodaCL)

print( "CL_SprintDecay" )
function CL_SprintDecay(ply, data)
	if ply:KeyPressed(IN_JUMP) && ply:OnGround() then
		if CL_GetEnergy() > 10 then
			if CL_HasSkill("skill_acro",2) then
				CL_SetEnergy(CL_GetEnergy() - 5)
			else
				CL_SetEnergy(CL_GetEnergy() - 10)
			end
		else
			CL_SetEnergy(0)
		end
	end
	if GetForceWalk() == true then
		return
	end
	if ply:KeyDown(IN_SPEED) && ply:OnGround() && !GetForceWalk() then
		if math.abs(data:GetForwardSpeed()) > 0 || math.abs(data:GetSideSpeed()) > 0 then
		--	data:SetMoveAngles(data:GetMoveAngles())
		--	data:SetSideSpeed(data:GetSideSpeed()* 0.1)
		--	data:SetForwardSpeed(data:GetForwardSpeed())
			if CL_GetEnergy() > 0 && CL_GetChargeInt() <= CurTime()  then
				CL_SetEnergy(CL_GetEnergy() - 1)
				LocalPlayer().ChargeInt = CurTime() + 0.05
			end
		end
	else
		if CL_GetEnergy() < 100 && CL_GetChargeInt() <= CurTime() then
			CL_SetEnergy(CL_GetEnergy() + 1)
			LocalPlayer().ChargeInt = CurTime() + 1
		end
	end
	if CL_GetEnergy() > 0 && !LocalPlayer().CanSprint then
		LocalPlayer().CanSprint = true
	elseif CL_GetEnergy() <= 0 && LocalPlayer().CanSprint  then
		LocalPlayer().CanSprint = false
		LocalPlayer().ChargeInt = CurTime() + 5
	end
end
hook.Add("Move", "CL_SprintDecay",  CL_SprintDecay)

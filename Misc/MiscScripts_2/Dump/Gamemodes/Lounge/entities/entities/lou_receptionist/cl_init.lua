include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:BuildBonePositions(NumBones, NumPhysBones)
end

function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn
end

function ENT:DoRagdollBone(PhysBoneNum, BoneNum)
end

function lou_receptionist_menu_hook(um)
	local DermaPanel = vgui.Create("DFrame")
	DermaPanel:SetPos(ScrW() / 2 - 150, ScrH() / 2 - 150)
	DermaPanel:SetSize(300, 300)
	DermaPanel:SetTitle("Receptionist")
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:MakePopup()
	
	MindySheet = vgui.Create("DPanelList")
	MindySheet:SetSpacing(5)
	MindySheet:SetPadding(5)
	
	local TextLabel = vgui.Create("DLabel")
	TextLabel:SetText("Make me say something:")
	TextLabel:SizeToContents()
	MindySheet:AddItem(TextLabel)
	
	local TextEntry = vgui.Create("DTextEntry")
	TextEntry:SetWide(200)
	MindySheet:AddItem(TextEntry)
	
	local TextSpeak = vgui.Create("DButton")
	TextSpeak:SetText("Speak!")
	TextSpeak.DoClick = function(TextSpeak)
		datastream.StreamToServer("lou_receptionist_speak", {TextEntry:GetValue()})
		DermaPanel:Remove()
	end
	MindySheet:AddItem(TextSpeak)
	
	MessageSheet = vgui.Create("DPanelList")
	MessageSheet:SetSpacing(5)
	MessageSheet:SetPadding(5)
	
	local PlayerList = vgui.Create("DListView")
	PlayerList:SetMultiSelect(false)
	PlayerList:AddColumn("Player Name")
	PlayerList:SetTall(100)
	for k, v in pairs(player.GetAll()) do
		PlayerList:AddLine(v:Nick())
	end
	MessageSheet:AddItem(PlayerList)
	
	local sheet = vgui.Create("DPropertySheet", DermaPanel)
	sheet:SetPos(10, 30)
	sheet:SetSize(DermaPanel:GetWide() - 20, DermaPanel:GetTall() - 40)
	sheet:AddSheet("Mindy", MindySheet, "gui/silkicons/help", false, false, "Interact with Mindy!")
	sheet:AddSheet("Messaging", MessageSheet, "gui/silkicons/note", false, false, "Have Mindy send a message for you!")
end
usermessage.Hook("lou_receptionist_menu", lou_receptionist_menu_hook)

function lou_receptionist_speak_hook(um)
	local name = um:ReadString()
	local text = um:ReadString()
	//if not Speak then Speak = vgui.Create("HTML") end
	//Speak:SetPos(-10, -10)
	//Speak:SetSize(0, 0)
	//Speak:OpenURL("http://say.expressivo.com/jennifer/"..text)
	chat.AddText(Color(255, 0, 149, 255), name, Color(255, 255, 255, 255), ": "..text)
end
usermessage.Hook("lou_receptionist_speak", lou_receptionist_speak_hook)
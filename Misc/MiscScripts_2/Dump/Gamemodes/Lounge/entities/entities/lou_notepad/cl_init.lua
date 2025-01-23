include('shared.lua')

function ENT:Draw()
	self.Entity:DrawModel()
end

function lob_notepad_hook(um)
	local text = um:ReadString()
	local DermaPanel = vgui.Create("DFrame")
	DermaPanel:SetPos(ScrW() / 2 - 150, ScrH() / 2 - 150)
	DermaPanel:SetSize(300, 300) 
	DermaPanel:SetTitle("Notepad")
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	
	DermaPanel:MakePopup()
	
	local TextLabel = vgui.Create("DLabel", DermaPanel)
	TextLabel:SetPos(10, 30)
	TextLabel:SetText(text)
	TextLabel:SizeToContents()
end
usermessage.Hook("lob_notepad", lob_notepad_hook)

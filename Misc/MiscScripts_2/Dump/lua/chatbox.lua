local PANEL = {}

AccessorFunc(PANEL, "_ko", "KeepOpen", FORCE_BOOL)

function PANEL:Init()
	self.ChatHistory = vgui.Create("DListView", self)
	self.ChatHistory:AddColumn("Text") -- Add column
end

function PANEL:Paint()
	
end

function PANEL:Think()
	
end

function PANEL:PerformLayout()
	self.ChatHistory:SetPos(10, 10)
	self.ChatHistory:SetWide(self:GetWide() - 20)
	self.ChatHistory:SetTall(self:GetTall() - 20)
end

function PANEL:AddChat(text)
	self.ChatHistory:AddLine(text)
end

vgui.Register("ChatBox", PANEL)






CHATBOX = vgui.Create("ChatBox")
CHATBOX:SetPos(30, ScrH() - 300)
CHATBOX:SetWide(500)
CHATBOX:SetTall(200)

hook.Add("OnPlayerChat", "PlayerChat", function(ply, text, teamchat, dead)
	CHATBOX:AddChat(ply:Nick() ..  ": " .. text)
end)

hook.Add("ChatText", "InfoMessages", function(plindex, plname, text, typ)
	CHATBOX:AddChat(text)
end)

hook.Add("StartChat", "StartChat", function()
	CHATBOX:SetKeepOpen(true)
	return true
end)

hook.Add("FinishChat", "FinishChat", function()
	CHATBOX:SetKeepOpen(false)
	return false
end)

hook.Add("ChatTextChanged", "TextChanged", function(text)
	
end)
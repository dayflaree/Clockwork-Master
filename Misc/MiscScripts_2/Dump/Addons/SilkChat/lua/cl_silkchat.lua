surface.CreateFont("coolvetica", 20, 400, true, false, "SilkChatFont", false, false)

local ChatBox = {}

ChatBox.ShowChat = false
ChatBox.Lines = {}
ChatBox.Chat = ""
ChatBox.TeamChat = false
ChatBox.TexIDs = {}
ChatBox.DefaultIcon = "information"

ChatBox.LinesToShow = 8

local function ToWidth(s)
	surface.SetFont("SilkChatFont")
	return surface.GetTextSize(s)
end

local function ColorAlpha(col, alpha)
	return Color(col.r, col.g, col.b, alpha)
end

function ChatBox.AddLine(icon, ...)
	table.insert(ChatBox.Lines, 1, {
		text = {...},
		time = CurTime(),
		icon = surface.GetTextureID("gui/silkicons/" .. icon)
	})
	ChatBox.Lines[ChatBox.LinesToShow + 1] = nil
end

local x, y = 35, ScrH() - 133
local chaticon, teamchaticon = surface.GetTextureID("gui/silkicons/world"), surface.GetTextureID("gui/silkicons/group")

hook.Add("HUDPaint", "DrawChat", function()
	for k, line in pairs(ChatBox.Lines) do
		if ChatBox.ShowChat or line.time > CurTime() - 20 then
			local alpha100 = 100
			local alpha255 = 255
			
			if ChatBox.ShowChat then
				alpha100 = 150
				alpha255 = 255
			else
				alpha100 = math.Clamp(5 - ((CurTime() - (line.time + 20))) * 20, 0, 100)
				alpha255 = math.Clamp(5 - ((CurTime() - (line.time + 20))) * 20, 0, 255)
			end
			
			local width = 0
			
			for _, part in pairs(line.text) do
				if type(part) == "string" then
					width = width + ToWidth(part)
				elseif type(part) == "Player" then
					width = width + ToWidth(part:Nick())
				end
			end
			
			draw.RoundedBox(6, x, y + (-30 * k), width + 30, 23, Color(0, 0, 0, alpha100))
			
			if line.icon then
				surface.SetTexture(line.icon)
				surface.SetDrawColor(255, 255, 255, alpha255)
				surface.DrawTexturedRect(x + 6, y + (-30 * k) + 3, 16, 16)
			end
			
			local cur_x = x + 26
			local last_color = Color(255, 255, 255, 0)
			
			for _, part in pairs(line.text) do
				if type(part) == "string" then
					draw.SimpleText(part, "SilkChatFont", cur_x, y + (-30 * k) + 2, ColorAlpha(last_color, alpha255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
					cur_x = cur_x + ToWidth(part)
				elseif type(part) == "Player" then
					draw.SimpleText(part:Nick(), "SilkChatFont", cur_x, y + (-30 * k) + 2, ColorAlpha(team.GetColor(part:Team()), alpha255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
					cur_x = cur_x + ToWidth(part:Nick())
				elseif type(part) == "table" then
					last_color = part
				end
			end
		end
	end
	
	if ChatBox.ShowChat then
		draw.RoundedBox(6, x, y, ToWidth(ChatBox.Chat) + 30, 23, Color(0, 0, 0, 100))
		if ChatBox.TeamChat then
			icon = teamchaticon
		else
			icon = chaticon
		end
		surface.SetTexture(icon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x + 6, y + 4, 16, 16)
		draw.SimpleText(ChatBox.Chat, "SilkChatFont", x + 26, y + 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end
end)

hook.Add("OnPlayerChat", "Text", function(ply, text, teamchat, dead)
	if ValidEntity(ply) then
		local icon
		
		if ply:IsAdmin() then
			icon = "shield"
		else
			icon = "user"
		end
		
		if teamchat then icon = "group" end
		
		ChatBox.AddLine(icon, ply, ": ", text)
	else
		ChatBox.AddLine("application", "Console: ", text)
	end
	
	return true
end)

hook.Add("ChatText", "ChatMessages", function(plindex, plname, text, typ)
	ChatBox.AddLine("information", text)
end)

local oldchatAddText = chat.AddText

function chat.AddText(...)
	local icon = false
	local to_remove = false
	
	for k, v in pairs({...}) do
		if type(v) == "table" and v.Icon and not v.r and not v.g and not v.b and not v.a then
			icon = v.Icon
			to_remove = k
		end
	end
	
	if not icon then
		icon = ChatBox.DefaultIcon
	else
		table.remove({...}, to_remove)
	end
	
	ChatBox.AddLine(icon, unpack({...}))
	oldchatAddText(Color(255, 255, 255), unpack({...}))
end

hook.Add("StartChat", "StartChat", function()
	ChatBox.ShowChat = true
	return true
end)

hook.Add("FinishChat", "FinishChat", function()
	ChatBox.ShowChat = false
	ChatBox.TeamChat = false
	return false
end)

hook.Add("ChatTextChanged", "TextChanged", function(text)
	ChatBox.Chat = text
end)

hook.Add("PlayerBindPress", "PlayerBindPress", function(ply, bind, pressed)
	if string.find(bind, "messagemode2") then
		ChatBox.TeamChat = true
	end
end)
include('shared.lua')

function ENT:Initialize() 
	function self.Chat(ply, text, teamonly, dead)
		if not teamonly then
			table.insert(self.Chats, { ply, text, CurTime() })
		end
	end
	hook.Add("OnPlayerChat", "ChatTextHook_" .. self:EntIndex(), self.Chat)
	
	function self.ChatChanged(text)
		self.CurrentText = text
	end
	hook.Add("ChatTextChanged", "ChatTextChangedHook_" .. self:EntIndex(), self.ChatChanged)

	self.CurrentText = ""
	self.Chats = {}
end

function ENT:OnRemove()
	hook.Remove("OnPlayerChat", "ChatTextHook_" .. self:EntIndex())
	hook.Remove("ChatTextChanged", "ChatTextChangedHook_" .. self:EntIndex())
end

function ENT:Draw()
	self:DrawModel()
	
	local pos = self:GetPos() + (self:GetUp() * 100)
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	surface.SetFont("HUDNumber2")
	
	cam.Start3D2D(pos, ang, 1)
	
		sx, sy = -540, 0
		
		surface.SetDrawColor(50, 50, 50, 150)
		surface.DrawRect(-550, 0, 1100, 520)
		
		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawRect(-550, 0, 1100, 50)
		
		draw.SimpleText("3D ChatBox by _Undefined", "HUDNumber2", sx + 40, sy + 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(surface.GetTextureID("gui/silkicons/user"))
		surface.DrawTexturedRect(sx, sy + 10, 32, 32)
		
		time = os.date("%I:%M:%S %p")
		local w, h = surface.GetTextSize(time)
		
		draw.SimpleText(time, "HUDNumber2", 540 - w, sy + 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		
		sx, sy = -530, 60
		
		for k, CHAT in pairs(self.Chats) do
			if CHAT[1]:IsAdmin() then
				material = "shield"
			else
				material = "user"
			end
			
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetTexture(surface.GetTextureID("gui/silkicons/"..material))
			surface.DrawTexturedRect(sx, sy + 5, 32, 32)
			
			draw.SimpleText(CHAT[1]:Nick(), "HUDNumber2", sx + 40, sy, team.GetColor(CHAT[1]:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			local w, h = surface.GetTextSize(CHAT[1]:Nick())
			draw.SimpleText(": "..CHAT[2], "HUDNumber2", sx + w + 40, sy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			sy = sy + 40
		end
		
		if #self.Chats < 1 then
			draw.SimpleText("SAY SOMETHING!", "HUDNumber5", sx, sy, Color(255, 20, 20, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
		
		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawRect(-500, 450, 1000, 50)
		draw.SimpleText(self.CurrentText, "HUDNumber2", sx + 35, sy + 395, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		
	cam.End3D2D()
end

function ENT:Think()
	for k, CHAT in pairs(self.Chats) do
		if CHAT[3] < CurTime() - 20 then
			table.remove(self.Chats, k)
		end
	end
end
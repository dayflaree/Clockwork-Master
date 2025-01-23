ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Minecraft Sign"
ENT.Author = "_Undefined (Model by The One Free-Man)"
ENT.Contact = ""
ENT.Purpose = "Place (un)informative signs."
ENT.Instructions = ""

ENT.Spawnable = true
ENT.AdminSpawnable = true

if SERVER then

	resource.AddFile("resource/fonts/minecraft.ttf")
	
	function ENT:SpawnFunction(ply, tr)
		if not tr.Hit then return end
		
		local ent = ents.Create(self.Classname)
		ent:SetPos(tr.HitPos + tr.HitNormal * 170)
		ent:SetAngles(ply:GetAngles() + Angle(0, 180, 0))
		
		ent:Spawn()
		ent:Activate()  
		
		umsg.Start("mc_sign_request_text")
			umsg.Entity(ent)
		umsg.End()
		
		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/signage/signage.mdl")
		self:SetMoveType(MOVETYPE_NONE)
	end

	function ENT:SetText(text1, text2, text3, text4)
		self:SetNWString("text1", text1)
		self:SetNWString("text2", text2)
		self:SetNWString("text3", text3)
		self:SetNWString("text4", text4)
	end
	
	concommand.Add("mc_sign_set_text", function(ply, cmd, args)
		local sign = Entity(args[1])
		local str = table.concat(args, " ", 2)
		local exp = string.Explode("|", str)
		sign:SetText(exp[2] or "", exp[3] or "", exp[4] or "", exp[5] or "")
	end)
	
end

if CLIENT then
	
	surface.CreateFont("minecraft", 48, 400, false, false, "mc_sign", false, false)
	
	function ENT:Draw()
		self:DrawModel()
		
		local pos = self:GetPos() + (self:GetForward() * 14.5) + (self:GetUp() * -136.8)
		local ang = self:GetAngles()
		
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 90)
		
		cam.Start3D2D(pos, ang, 0.07)
			draw.SimpleText(self:GetNWString("text1", ""), "mc_sign", 0, 0, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self:GetNWString("text2", ""), "mc_sign", 0, 55, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self:GetNWString("text3", ""), "mc_sign", 0, 115, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self:GetNWString("text4", ""), "mc_sign", 0, 175, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
	
	usermessage.Hook("mc_sign_request_text", function(um)
		ent = um:ReadEntity()
		local l1, l2, l3, l4
		
		Derma_StringRequest("Line 1", "Line 1 text", "", function(text)
			l1 = text
			Derma_StringRequest("Line 2", "Line 2 text", "", function(text)
				l2 = text
				Derma_StringRequest("Line 3", "Line 3 text", "", function(text)
					l3 = text
					Derma_StringRequest("Line 4", "Line 4 text", "", function(text)
						l4 = text
						RunConsoleCommand("mc_sign_set_text", ent:EntIndex(), " |", l1, "|", l2, "|", l3, "|", l4)
					end)
				end)
			end)
		end)
	end)
end
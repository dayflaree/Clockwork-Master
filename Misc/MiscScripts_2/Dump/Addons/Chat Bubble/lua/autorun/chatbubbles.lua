if CLIENT then
	hook.Add("StartChat", "CreateBubble", function()
		RunConsoleCommand("cb_startchat")
	end)
	
	hook.Add("FinishChat", "RemoveBubble", function()
		RunConsoleCommand("cb_finishchat")
	end)
end

if SERVER then
	AddCSLuaFile("autorun/chatbubbles.lua")
	
	concommand.Add("cb_startchat", function(ply, cmd, args)
		if not ply.chatbubble then
			local ent = ents.Create("chat_bubble")
			ent:SetPos(ply:GetPos() + Vector(0, 0, 90))
			ent:Spawn()
			
			ent:SetNWEntity("player", ply)
			ply.chatbubble = ent
		else
			ply.chatbubble:SetColor(255, 255, 255, 255)
		end
	end)
	
	concommand.Add("cb_finishchat", function(ply, cmd, args)
		if ply.chatbubble and ply.chatbubble:IsValid() then
			ply.chatbubble:SetColor(255, 255, 255, 0)
		end
	end)
end
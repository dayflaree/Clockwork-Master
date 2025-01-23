usermessage.Hook("lolbot", function(um)
	local name = um:ReadString()
	local text = glon.decode(um:ReadString()) or false
	if text then
		chat.AddText(Color(255, 0, 255), name, Color(255, 255, 255, 0), ": "..text[1])
	end
end)

hook.Add("HUDPaint", "lolbot_hudpaint", function()
	for k, npc in pairs(ents.FindByClass("npc_kleiner")) do
		if npc:GetNWBool("lolbot") then
			local wpos = npc:GetPos() + Vector(0, 0, 80)
			local pos = wpos:ToScreen()
			if pos.visible and wpos:Distance(LocalPlayer():GetShootPos()) < 1000 then
				draw.DrawText("lolbot", "ScoreboardText", pos.x, pos.y, Color(255, 0, 255), TEXT_ALIGN_CENTER)
			end
		end
	end
end)
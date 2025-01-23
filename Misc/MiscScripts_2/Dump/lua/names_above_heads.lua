hook.Add("HUDPaint", "names_above_heads", function()
	for k, ply in pairs(player.GetAll()) do
		if ply ~= LocalPlayer() then
			local pos = ply:GetShootPos():ToScreen()
			draw.SimpleText(ply:Nick(), "ScoreboardText", pos.x, pos.y - 20, team.GetColor(ply:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end)
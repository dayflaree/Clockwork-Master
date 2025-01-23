hook.Add("HUDPaint", "SBCHUDPaint", function()
	if LocalPlayer():DoingChallenge() then
		local c = LocalPlayer():CurrentChallenge()
		
		if c.Hooks and c.Hooks.HUDPaint then
			c.Hooks.HUDPaint()
		end
	end
end)
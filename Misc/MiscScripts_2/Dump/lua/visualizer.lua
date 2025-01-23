require("bass")

chan = nil

local num = 20
local width = ScrW() / num

local lasty = 0

local pos = Vector(0, 0, 0)

BASS.StreamFileURL("http://basementbeatz.files.wordpress.com/2008/05/06-justice-stress-auto-remix.mp3", 0, function(channel, errorcode)
-- BASS.StreamFileURL("http://localhost/1.mp3", 0, function(channel, errorcode)
	if errorcode == 0 then
		channel:play()
		channel:setvolume(100)
		-- channel:set3dposition(pos, Vector(0, 0, 0), Vector(0, 0, 0))
		chan = channel
	end
end)

function Average(start, num)
	if chan and chan:getplaying() then
		local tbl = chan:fft2048()

		if start < 1 then start = 1 end
		return (tbl[start] + tbl[start + num]) / 2
	end
end

local maxlow = 0
local maxmid = 0
local maxhigh = 0

hook.Add("HUDPaint", "vis", function()
	if chan and chan:getplaying() then
		local low = math.Round(Average(1, 200) * 1000)
		local mid = math.Round(Average(200, 400) * 1000)
		local high = math.Round(Average(600, 400) * 1000)
		
		if low > maxlow then maxlow = low end
		if mid > maxmid then maxmid = mid end
		if high > maxhigh then maxhigh = high end
		
		--MsgN("Low: " .. low)
		draw.SimpleText(maxlow, "ScoreboardText", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(maxmid, "ScoreboardText", 10, 30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(maxhigh, "ScoreboardText", 10, 50, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end
end)

hook.Add("RenderScreenspaceEffects", "Sunbeams_Fun", function()
    local source_pos = pos
     
    -- it's recommended to use calcview's eye angles and origin
    -- so they will be relative to camera and not your player head
    local eye_angles = LocalPlayer():EyeAngles()
    local eye_origin = LocalPlayer():EyePos()
     
    local fade = math.max(eye_angles:Forward():DotProduct((source_pos - eye_origin):Normalize()), 0)
      
    if fade == 0 then return end
      
    local screen_pos = source_pos:ToScreen()
      
end)

hook.Add("Think", "vis", function()
	if chan and chan:getplaying() then
		local low = math.Round(Average(1, 200) * 1000)
		local mid = math.Round(Average(200, 400) * 1000)
		local high = math.Round(Average(600, 400) * 1000)
		
		if low > 7 then
			local em = ParticleEmitter(pos)
			for i = 1, low do
				local part = em:Add("sprites/light_glow02_add", pos)
				if part then
					part:SetColor(math.random(255), 0, 0, 255)
					part:SetVelocity(VectorRand() * 100)
					part:SetGravity(Vector(0, 0, 500))
					part:SetDieTime(0.5)
					part:SetLifeTime(0)
					part:SetStartSize(40)
					part:SetEndSize(0)
				end
			end
			em:Finish()
		end
		
		if mid > 3 then
			local em = ParticleEmitter(pos)
			for i = 1, mid do
				local part = em:Add("sprites/light_glow02_add", pos)
				if part then
					part:SetColor(0, math.random(255), 0, 255)
					part:SetVelocity(VectorRand() * 50)
					part:SetGravity(Vector(0, 0, 500))
					part:SetDieTime(1)
					part:SetLifeTime(0)
					part:SetStartSize(20)
					part:SetEndSize(5)
				end
			end
			em:Finish()
		end
	end
end)

hook.Add("PostDrawOpaqueRenderables", "vis", function()
	if chan and chan:getplaying() then
		cam.Start3D2D(Vector(0, 0, 0), Angle(0, 90, 90), 1)
			local x = 0 -- ScrW() / 2 - ((num / 2) * width)
			local y = 0 -- ScrW() / 2 - 100
			
			lasty = y
			
			for i = 0, num - 1 do
				local n = math.Round(1024 / num)
				local h = Average(i * n, n) * 10000 --, 0, 200)
				if h < 10 then h = 10 end
				
				surface.SetDrawColor(255, 255, 255, 255)
				
				-- Bars
				-- draw.RoundedBox(0, x + (width * i), y + -h, width, h, Color(255, 255, 255, 255))
				
				-- Line
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawLine(x + (width * i), lasty, x + (width * i) + width, y + -h)
				lasty = y + -h
				
				-- Crosses
				-- surface.DrawLine(x + (width * i), y, x + (width * i) + width, y + -h)
				-- surface.DrawLine(x + (width * i) + width, y, x + (width * i), y + -h)
			end
		cam.End3D2D()
	end
end)
require("bass")
chan = nil
local num = 10
local pos = Vector(0, 0, 0)

blocks = {}

for l = 1, num do
	blocks[l] = {}
	for c = 1, num do
		blocks[l][c] = {}
		for r = 1, num do
			local block = ClientsideModel("models/hunter/blocks/cube05x05x05.mdl")
			block:SetPos(pos + Vector(l * 22, c * 22, r * 22))
			--block:SetNoDraw(true)
			blocks[l][c][r] = block
		end
	end
end

BASS.StreamFileURL("http://basementbeatz.files.wordpress.com/2008/05/06-justice-stress-auto-remix.mp3", 0, function(channel, errorcode)
-- BASS.StreamFileURL("http://localhost/1.mp3", 0, function(channel, errorcode)
	if errorcode == 0 then
		channel:play()
		channel:setvolume(0)
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

hook.Add("HUDPaint", "vis", function()
	if chan and chan:getplaying() then
		local y = 20
		for i = 0, num - 1 do
			local n = math.Round(1024 / num)
			local h = math.Round(math.Clamp(Average(i * n, n) * 1000, 0, 10))
			draw.SimpleText(h, "ScoreboardText", 10, y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			y = y + 20
		end
	end
end)

hook.Add("Think", "vis", function()
	if chan and chan:getplaying() then
	
		local heights = {}
		
		for i = 0, num - 1 do
			local n = math.Round(1024 / num)
			local h = math.Clamp(Average(i * n, n) * 10000, 0, 200)
			
			heights[i + 1] = h
		end
		
		for _, column in pairs(blocks) do
			for height, row in pairs(column) do
				if height <= heights[height] then
					for height, block in pairs(row) do
						if height <= heights[height] then
							block:SetColor(255, 0, 0, 255)
						else
							block:SetColor(0, 0, 0, 0)
						end
					end
				end
			end
		end
	end
end)